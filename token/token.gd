extends Node2D

signal selection(id)

var is_dragging = false
var selected = false
var hex_grid : TileMapLayer = null
var last_coor : Vector2 = Vector2(0, 0)

const DICES = preload("res://dices/dices.tscn")
const CHARGES_DICE = preload("res://dices/charges.tscn")

@export var moves = 40
@export var move_range = 1
@export var attack_range = 2
@export var power = 4

@export var hided = false
@export var in_region = ""

@export var stats = {}
@export var id : String

@onready var grid_markers: Node2D = $"../../GridMarkers"
@onready var target_markers: Node2D = $"../../TargetMarkers"
const GRID_MARKER = preload("res://token/grid_marker.tscn")
const TARGET_MARKER = preload("res://token/target_marker.tscn")

@onready var icon_texture: TextureRect = $BG/Icon
@onready var selected_hex_texture: TextureRect = $SelectedHex
@onready var token_texture: TextureRect = $Token
@onready var bg_token_texture: TextureRect = $BG
@onready var res_container: HBoxContainer = $Token/ResContainer
@onready var ficha_container: PanelContainer = $"../../HUD/FichaContainer"


func _ready() -> void:
	load_data()
	apply_hex_color()
	
	selection.connect(get_tree().current_scene._on_selected_token)
	selection.connect(ficha_container._on_selected_token)
	hex_grid = get_tree().get_first_node_in_group("grid")
	if multiplayer.is_server():
		snap_to_grid()
	
	update_hud()

func _process(_delta: float) -> void:
	if is_dragging:
		var mouse_pos = get_global_mouse_position()
		if multiplayer.is_server():
			global_position = mouse_pos
		else:
			rpc_id(1, "atualizar_arrasto_tempo_real", mouse_pos)

func _on_button_button_down() -> void:
	if not selected:
		selected = true
		update_hud()
		selection.emit(name)
		return
	get_parent().move_child(self, -1)
	is_dragging = true
	spawn_marker()

func _on_button_button_up() -> void:
	is_dragging = false
	if hex_grid:
		var self_coor = hex_grid.local_to_map(global_position)
		var can_move_to = []
		for child in grid_markers.get_children():
			if child.parent == self:
				can_move_to.append(Vector2i(hex_grid.local_to_map(child.global_position)))
		clear_marker()
		rpc_id(1, "finalizar_movimento_no_servidor", Vector2i(self_coor), can_move_to)
	else:
		print("Grid não encontrada!")

func snap_to_grid() -> void:
	var self_coor = hex_grid.local_to_map(global_position)
	global_position = hex_grid.map_to_local(self_coor)
	last_coor = hex_grid.local_to_map(global_position)

func spawn_marker() -> void:
	if moves <= 0:
		return
	
	var center_cell = hex_grid.local_to_map(global_position)
	var visited = {}
	var current_fringe = [center_cell]
	visited[center_cell] = true
	
	for step in range(move_range):
		var next_fringe = []
		
		for cell in current_fringe:
			var neighbors = hex_grid.get_surrounding_cells(cell)
			for neighbor in neighbors:
				if not visited.has(neighbor):
					visited[neighbor] = true
					next_fringe.append(neighbor)
		current_fringe = next_fringe
	var pos_to_spawn = visited.keys()
	pos_to_spawn.erase(center_cell)
	
	for pos in pos_to_spawn:
		var new_marker = GRID_MARKER.instantiate()
		new_marker.global_position = hex_grid.map_to_local(pos)
		new_marker.parent = self
		grid_markers.add_child(new_marker)
	
func clear_marker() -> void:
	var child = grid_markers.get_children()
	for i in child:
		i.queue_free()

func attack() -> void:
	var center_cell = hex_grid.local_to_map(global_position)
	var visited = {}
	var current_fringe = [center_cell]
	visited[center_cell] = true
	
	for step in range(attack_range):
		var next_fringe = []
		
		for cell in current_fringe:
			var neighbors = hex_grid.get_surrounding_cells(cell)
			for neighbor in neighbors:
				if not visited.has(neighbor):
					visited[neighbor] = true
					next_fringe.append(neighbor)
		current_fringe = next_fringe
	var pos_to_spawn = visited.keys()
	#pos_to_spawn.erase(center_cell)
	
	for pos in pos_to_spawn:
		var new_marker = TARGET_MARKER.instantiate()
		new_marker.global_position = hex_grid.map_to_local(pos)
		new_marker.parent = self
		new_marker.power = power
		target_markers.add_child(new_marker)

func _on_hide_toggled(toggled_on: bool) -> void:
	hided = toggled_on
	if hided:
		esconder_menos_pro_host.rpc()
	else:
		mostrar_para_todos.rpc()

func apply_hex_color() -> void:
	if not stats:
		return
	token_texture.self_modulate = stats["token_color"]
	get_parent().get_parent().definir_ficha()
	bg_token_texture.self_modulate = token_texture.self_modulate.darkened(0.4)
	selected_hex_texture.self_modulate = token_texture.self_modulate.darkened(0.8)

func load_data() -> void:
	stats = TokensData.players.get(id)
	if stats:
		icon_texture.texture = stats["icon"]
	

# "authority" significa: apenas o Servidor/Host pode mandar os outros executarem.
# "call_local" significa: o Host também vai rodar essa função na tela dele.
# "reliable" significa: o pacote de dados TEM que chegar (essencial para status/vida).

@rpc("any_peer", "call_local", "reliable")
func take_damage(amount: int) -> void:
	if not multiplayer.is_server():
		return
	stats["vida"] -= amount
	update_hud.rpc()

@rpc("any_peer", "unreliable")
func atualizar_arrasto_tempo_real(new_pos: Vector2):
	if not multiplayer.is_server():
		return
	global_position = new_pos

@rpc("any_peer", "call_local", "reliable")
func finalizar_movimento_no_servidor(self_coor: Vector2i, can_move_to: Array):
	if not multiplayer.is_server(): 
		return 
	
	if can_move_to.has(self_coor) and moves > 0:
		moves -= 1
		global_position = hex_grid.map_to_local(self_coor)
		last_coor = self_coor
	else:
		global_position = hex_grid.map_to_local(last_coor)
		
	update_hud.rpc()

@rpc("any_peer", "call_local")
func spawn_dice(type, advantage = 0, bonus = 0, secret = false):
	if not multiplayer.is_server():
		return
	
	var quem_solicitou = multiplayer.get_remote_sender_id()
	
	for child in $Dices.get_children():
		child.queue_free()
	
	
	for i in range(advantage + 1):
		var new_dice = DICES.instantiate()
		new_dice.type = type
		new_dice.bonus = bonus
		$Dices.add_child(new_dice, true)
	
	if secret:
		hide_dice.rpc(quem_solicitou)
	else:
		show_dice.rpc()

@rpc("any_peer", "call_local")
func spawn_charges(amount, value, crit, type):
	if not multiplayer.is_server():
		return
	
	for child in $Dices.get_children():
		child.queue_free()
		
	for child in $CenterContainer.get_children():
		child.queue_free()
	
	var new_dice = CHARGES_DICE.instantiate()
	new_dice.amount = amount
	new_dice.type = type
	$CenterContainer.add_child(new_dice, true)


@rpc("any_peer", "call_local")
func hide_dice(id_do_dono: int):
	if multiplayer.get_unique_id() == id_do_dono:
		return
	$Dices.visible = false

@rpc("any_peer", "call_local")
func show_dice():
	$Dices.visible = true


@onready var hide_toggle: CheckButton = $HideToggle
@onready var name_label: Label = $Name

@onready var hp_bar: ProgressBar = $Token/Bars/HpBar
@onready var hp_label: Label = $Token/Bars/HpBar/HpContainer/Hp
@onready var max_hp_label: Label = $Token/Bars/HpBar/HpContainer/MaxHp

@onready var temp_hp_bar: ProgressBar = $Token/Bars/HpBar/TempHpBar

@onready var san_bar: ProgressBar = $Token/Bars/SanBar
@onready var san_label: Label = $Token/Bars/SanBar/SanContainer/San
@onready var max_san_label: Label = $Token/Bars/SanBar/SanContainer/MaxSan

@onready var postura_bar: ProgressBar = $Token/Bars/PosturaBar
@onready var postura_label: Label = $Token/Bars/PosturaBar/PosturaContainer/Postura
@onready var max_postura_label: Label = $Token/Bars/PosturaBar/PosturaContainer/MaxPostura

@onready var resist_fisica_label: Label = $Token/ResContainer/ResFTexture/Label
@onready var resist_magica_label: Label = $Token/ResContainer/ResMTexture/Label

@onready var moves_value: Label = $MovesContainer/Moves
@onready var moves_container: HBoxContainer = $MovesContainer

@rpc("authority", "call_local", "reliable")
func update_hud() -> void:
	moves_value.text = str(moves)
	selected_hex_texture.visible = selected
	if stats:
		name_label.text = stats["name"]
		icon_texture.texture = stats["icon"]
		
		hp_bar.max_value = stats["max_vida"]
		hp_bar.value = stats["vida"]
		max_hp_label.text = str(stats["max_vida"])
		hp_label.text = str(stats["vida"])
		
		if stats["vidatemp"] > 0:
			temp_hp_bar.show()
			temp_hp_bar.max_value = stats["max_vidatemp"]
			temp_hp_bar.value = stats["vidatemp"]
		else:
			temp_hp_bar.hide()
		
		san_bar.max_value = stats["max_sanidade"]
		san_bar.value = stats["sanidade"]
		max_san_label.text = str(stats["max_sanidade"])
		san_label.text = str(stats["sanidade"])
		
		if stats["max_postura"] > 0:
			postura_bar.max_value = stats["max_postura"]
			postura_bar.value = stats["postura"]
			max_postura_label.text = str(stats["max_postura"])
			postura_label.text = str(stats["postura"])
		else:
			postura_bar.hide()
		
		resist_fisica_label.text = str(stats["resist_fisica"])
		resist_magica_label.text = str(stats["resist_magica"])
		
	
	if multiplayer.is_server():
		hide_toggle.visible = selected

func _on_button_mouse_entered() -> void:
	z_index = 1
	san_bar.show()
	if stats:
		if stats["postura"] > 0:
			postura_bar.show()
	moves_container.show()
	res_container.show()
	res_container.position.y -= 30
	$Token/Bars.position.y -= 30

func _on_button_mouse_exited() -> void:
	z_index = 0
	san_bar.hide()
	if stats:
		if stats["postura"] > 0:
			postura_bar.hide()
	moves_container.hide()
	res_container.hide()
	res_container.position.y += 30
	$Token/Bars.position.y += 30

@rpc("any_peer", "call_local")
func esconder_menos_pro_host() -> void:
	if multiplayer.get_unique_id() != 1:
		hide()
	modulate = Color(1,1,1, 0.5)

@rpc("any_peer", "call_local")
func mostrar_para_todos() -> void:
	show()
	modulate = Color(1,1,1, 1)
