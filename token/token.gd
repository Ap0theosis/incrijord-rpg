extends Node2D

signal selection(id)

var is_dragging = false
var selected = false
var hex_grid : TileMapLayer = null
var last_coor : Vector2 = Vector2(0, 0)

var health = 16
var max_health = 16
var moves = 4

@export var token_name : String = ""
@export var token_icon : Texture2D 

@onready var grid_markers: Node2D = $"../../GridMarkers"
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
	hp_bar.value = health
	
	hex_grid = get_tree().get_first_node_in_group("grid")
	snap_to_grid()
	update_hud()
	icon_texture.texture = token_icon

func _process(_delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position()

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
			if child.parent == name:
				can_move_to.append(hex_grid.local_to_map(child.global_position))
		print("Última posição: %s\nMovimentos possíveis: %s\nTentou se mover para: %s" % [last_coor, can_move_to, self_coor])
		if not can_move_to.has(self_coor):
			global_position = hex_grid.map_to_local(last_coor)
			clear_marker()
			return
		
		if moves > 0:
			moves -= 1
			snap_to_grid()
			update_hud()
			clear_marker()
			return
		global_position = hex_grid.map_to_local(last_coor)
		clear_marker()
	else:
		print("Grid não encontrada!")

func snap_to_grid() -> void:
	var self_coor = hex_grid.local_to_map(global_position)
	global_position = hex_grid.map_to_local(self_coor)
	last_coor = hex_grid.local_to_map(global_position)

func spawn_marker() -> void:
	if moves <= 0:
		return
	var surround = hex_grid.get_surrounding_cells(hex_grid.local_to_map(global_position))
	for pos in surround:
		print("Posição do vizinho %s: %s" % [pos, hex_grid.map_to_local(pos)])
		var new_marker = GRID_MARKER.instantiate()
		new_marker.global_position = hex_grid.map_to_local(pos)
		new_marker.parent = name
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
	#var target_distance = abs(tile_a.x - tile_b.x) + abs(tile_a.y - tile_b.y)
	var surround = hex_grid.get_surrounding_cells(hex_grid.local_to_map(global_position))
	for pos in surround:
		print("Posição do vizinho %s: %s" % [pos, hex_grid.map_to_local(pos)])
		var new_marker = TARGET_MARKER.instantiate()
		new_marker.global_position = hex_grid.map_to_local(pos)
		new_marker.parent = name
		grid_markers.add_child(new_marker)

func update_hud() -> void:
	moves_value.text = str(moves)
	hp_label.text = str(health)
	max_hp_label.text = str(max_health)
	
	selected_hex.visible = selected
	name_label.text = token_name
