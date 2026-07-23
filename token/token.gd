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
@export var stats_hided = false
@export var name_hided = false
@export var in_region = ""

@export var stats: TokenData
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

@onready var main: Node2D = $"../.."

@onready var bars: VBoxContainer = $Token/Bars

func _ready() -> void:
	load_data()
	apply_hex_color()
	
	selection.connect(ficha_container._on_selected_token)
	hex_grid = get_tree().get_first_node_in_group("grid")
	if multiplayer.is_server():
		snap_to_grid()
	
	update_hud()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("special"):
		ServerSaver.salvar_ficha(stats)
	if Input.is_action_just_pressed("special2"):
		carregar_save_do_token()
	
	if is_dragging:
		var mouse_pos = get_global_mouse_position()
		if multiplayer.is_server():
			global_position = mouse_pos
		else:
			rpc_id(1, "atualizar_arrasto_tempo_real", mouse_pos)

func _on_button_button_down() -> void:
	if stats_hided and not multiplayer.is_server():
		return
	
	if not selected:
		selected = true
		update_hud()
		selection.emit(name)
		return
	get_parent().move_child(self, -1)
	is_dragging = true
	
	if not main.free_movement:
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



func apply_hex_color() -> void:
	if not stats:
		return
	token_texture.self_modulate = stats.token_cor
	ficha_container.definir_ficha()
	bg_token_texture.self_modulate = token_texture.self_modulate.darkened(0.4)
	selected_hex_texture.self_modulate = token_texture.self_modulate.darkened(0.8)

func load_data() -> void:
	stats = TokensManager.players[id]
	if stats:
		icon_texture.texture = stats.icone
	

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
	
	if main.free_movement and not self in main.iniciativa:
		global_position = hex_grid.map_to_local(self_coor)
		last_coor = self_coor
		update_hud.rpc()
		return
	if can_move_to.has(self_coor) and moves > 0:
		moves -= 1
		global_position = hex_grid.map_to_local(self_coor)
		last_coor = self_coor
	else:
		global_position = hex_grid.map_to_local(last_coor)
		
	update_hud.rpc()

func solicitar_rolagem(type, advantage = 0, bonus = 0, secret = false) -> void:
	spawn_dice.rpc_id(1, type, advantage, bonus, secret)

@rpc("any_peer", "call_local", "reliable")
func spawn_dice(type, advantage = 0, bonus = 0, secret = false):
	var sender_id = multiplayer.get_remote_sender_id()
	if sender_id == 0:
		sender_id = multiplayer.get_unique_id()
	
	if not multiplayer.is_server():
		return
	
	var quem_solicitou = multiplayer.get_remote_sender_id()
	
	for child in $Dices.get_children():
		child.queue_free()
	
	for child in $CenterContainer.get_children():
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
	new_dice.value = value
	new_dice.type = type
	print("critico para aplicar:" + str(crit))
	new_dice.crit_mult = crit
	$CenterContainer.add_child(new_dice, true)


@rpc("any_peer", "call_local")
func hide_dice(id_do_dono: int):
	if multiplayer.get_unique_id() == id_do_dono:
		return
	$Dices.visible = false

@rpc("any_peer", "call_local")
func show_dice():
	$Dices.visible = true


@onready var hide_toggle: CheckButton = $PanelContainer2/HBoxContainer/HideToggle
@onready var hidestats_toggle: CheckButton = $PanelContainer2/HBoxContainer/HideStatsToggle
@onready var hidename_toggle: CheckButton = $PanelContainer2/HBoxContainer/HideNameToggle
@onready var hide_container: PanelContainer = $PanelContainer2


@onready var name_label: Label = $PanelContainer/Name

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

@rpc("any_peer", "call_local", "reliable")
func update_hud() -> void:
	moves_value.text = str(moves)
	selected_hex_texture.visible = selected
	if stats:
		if not name_hided:
			name_label.text = stats.nome
		icon_texture.texture = stats.icone
		
		hp_bar.max_value = stats.max_vida
		hp_bar.value = stats.vida
		max_hp_label.text = str(stats.max_vida)
		hp_label.text = str(stats.vida)
		
		if stats.vidatemp > 0:
			temp_hp_bar.show()
			temp_hp_bar.max_value = stats.max_vidatemp
			temp_hp_bar.value = stats.vidatemp
		else:
			temp_hp_bar.hide()
		
		san_bar.max_value = stats.max_sanidade
		san_bar.value = stats.sanidade
		max_san_label.text = str(stats.max_sanidade)
		san_label.text = str(stats.sanidade)
		
		if stats.max_postura > 0:
			postura_bar.max_value = stats.max_postura
			postura_bar.value = stats.postura
			max_postura_label.text = str(stats.max_postura)
			postura_label.text = str(stats.postura)
		else:
			postura_bar.hide()
		
		resist_fisica_label.text = str(stats.resist_fisica)
		resist_magica_label.text = str(stats.resist_magica)
		
	
	if multiplayer.is_server():
		hide_container.visible = selected

func _on_button_mouse_entered() -> void:
	z_index = 1
	if stats_hided and not multiplayer.is_server():
		return
	san_bar.show()
	if stats:
		if stats.postura > 0:
			postura_bar.show()
	if self in main.iniciativa:
		moves_container.show()
	res_container.show()
	res_container.position.y -= 30
	$Token/Bars.position.y -= 30

func _on_button_mouse_exited() -> void:
	z_index = 0
	if stats_hided and not multiplayer.is_server():
		return
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

@rpc("any_peer", "call_local")
func esconder_stats_menos_pro_host() -> void:
	if multiplayer.get_unique_id() != 1:
		bars.hide()
		res_container.hide()
		moves_container.hide()
	bars.modulate = Color(1,1,1, 0.5)
	res_container.modulate = Color(1,1,1, 0.5)
	moves_container.modulate = Color(1,1,1, 0.5)

@rpc("any_peer", "call_local")
func mostrar_stats_para_todos() -> void:
	bars.show()
	res_container.show()
	moves_container.show()
	bars.modulate = Color(1,1,1, 1)
	res_container.modulate = Color(1,1,1, 1)
	moves_container.modulate = Color(1,1,1, 1)

@rpc("any_peer", "call_local")
func esconder_name_menos_pro_host() -> void:
	if multiplayer.get_unique_id() != 1:
		name_label.text = "???"
		return
	name_label.text = stats.nome + "(???)"

@rpc("any_peer", "call_local")
func mostrar_name_para_todos() -> void:
	name_label.text = stats.nome

func _on_hide_toggled(toggled_on: bool) -> void:
	hided = toggled_on
	if hided:
		esconder_menos_pro_host.rpc()
	else:
		mostrar_para_todos.rpc()

func _on_hide_stats_toggled(toggled_on: bool) -> void:
	stats_hided = toggled_on
	if stats_hided:
		esconder_stats_menos_pro_host.rpc()
	else:
		mostrar_stats_para_todos.rpc()

func _on_hide_name_toggled(toggled_on: bool) -> void:
	name_hided = toggled_on
	if name_hided:
		esconder_name_menos_pro_host.rpc()
	else:
		mostrar_name_para_todos.rpc()

func carregar_save_do_token() -> void:
	if not multiplayer.is_server():
		return # Apenas o Host carrega do disco
		
	var dados_carregados = ServerSaver.carregar_ficha(stats.id)
	if dados_carregados:
		# 1. Atualiza no Host
		stats = dados_carregados
		
		# 2. Injeta nos Clientes instantaneamente! (sem passar ID = manda pra todos)
		Rede.transmitir_token(self)

@rpc("any_peer", "call_local", "reliable")
func sincronizar_atributo(propriedade: String, new_valor) -> void:
	if not stats:
		return
	
	# 1. Atualiza a propriedade no Resource do Token em TODAS as máquinas
	stats.set(propriedade, new_valor)
	
	# 2. Se mudou a cor, atualiza a textura do nó 2D no mapa para todo mundo
	if propriedade == "token_cor":
		apply_hex_color()
		
	# 3. Atualiza o HUD visual flutuante do token (vida/sanidade em cima da cabeça)
	update_hud()

	# 4. Se a ficha aberta na tela DESTE jogador for a DESTE token, redesenha a UI
	var ficha = ficha_container
	if ficha and ficha.token == self:
		ficha.definir_ficha()

@rpc("any_peer", "call_local", "reliable")
func sincronizar_pericia(categoria: String, nome_pericia: String, novo_valor: int) -> void:
	if not stats:
		return
	
	stats.pericias[categoria][nome_pericia]["value"] = novo_valor
	
	var ficha = ficha_container
	if ficha and ficha.token == self:
		ficha.definir_ficha()


func _on_delete_pressed() -> void:
	queue_free()
