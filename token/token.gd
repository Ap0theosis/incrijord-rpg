extends Node2D

signal selection(id)

var is_dragging = false
var selected = false
var hex_grid : TileMapLayer = null
var last_coor : Vector2 = Vector2(0, 0)

const DICES = preload("res://dices/dices.tscn")

@export var health = 16
@export var max_health = 16
@export var moves = 40
@export var move_range = 1
@export var attack_range = 2
@export var power = 4

@export var token_name : String = ""
@export var token_icon : Texture2D 

@onready var grid_markers: Node2D = $"../../GridMarkers"
@onready var target_markers: Node2D = $"../../TargetMarkers"
const GRID_MARKER = preload("res://token/grid_marker.tscn")
const TARGET_MARKER = preload("res://token/target_marker.tscn")

@onready var hp_bar: ProgressBar = $Token/Bars/HpBar
@onready var hp_label: Label = $Token/Bars/HpBar/HpContainer/Hp
@onready var max_hp_label: Label = $Token/Bars/HpBar/HpContainer/MaxHp
@onready var selected_hex: TextureRect = $SelectedHex

@onready var san_bar: ProgressBar = $Token/Bars/SanBar
@onready var postura_bar: ProgressBar = $Token/Bars/PosturaBar
@onready var moves_value: Label = $MovesContainer/Moves
@onready var moves_container: HBoxContainer = $MovesContainer
@onready var name_label: Label = $Name
@onready var icon_texture: TextureRect = $BG/Icon

func _ready() -> void:
	selection.connect(get_tree().current_scene._on_selected_token)
	hp_bar.max_value = max_health
	hex_grid = get_tree().get_first_node_in_group("grid")
	if multiplayer.is_server():
		snap_to_grid()
	update_hud()
	icon_texture.texture = token_icon

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
	print("snap grid")
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

func _on_button_mouse_entered() -> void:
	z_index = 1
	san_bar.show()
	postura_bar.show()
	moves_container.show()
	$Token/Bars.position.y -= 30

func _on_button_mouse_exited() -> void:
	z_index = 0
	san_bar.hide()
	postura_bar.hide()
	moves_container.hide()
	$Token/Bars.position.y += 30

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

# --- FUNÇÕES DE REDE (RPC) ---
# "authority" significa: apenas o Servidor/Host pode mandar os outros executarem.
# "call_local" significa: o Host também vai rodar essa função na tela dele.
# "reliable" significa: o pacote de dados TEM que chegar (essencial para status/vida).

@rpc("any_peer", "call_local", "reliable")
func take_damage(amount: int) -> void:
	if not multiplayer.is_server():
		return
	health -= amount
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
func spawn_dice(_type):
	if not multiplayer.is_server():
		return
	
	var new_dice = DICES.instantiate()
	$Dices.add_child(new_dice)

@rpc("authority", "call_local", "reliable")
func update_hud() -> void:
	moves_value.text = str(moves)
	hp_label.text = str(health)
	hp_bar.value = health
	max_hp_label.text = str(max_health)
	
	selected_hex.visible = selected
	name_label.text = token_name
