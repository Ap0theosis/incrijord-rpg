extends Node2D

var is_dragging = false
var hex_grid : TileMapLayer = null

const GRID_MARKER = preload("res://grid_marker.tscn")

@onready var hp_bar: ProgressBar = $Token/Bars/HpBar
@onready var san_bar: ProgressBar = $Token/Bars/SanBar
@onready var postura_bar: ProgressBar = $Token/Bars/PosturaBar

func _ready() -> void:
	hex_grid = get_tree().get_first_node_in_group("grid")

func _process(_delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position()

func _on_button_button_down() -> void:
	is_dragging = true

func _on_button_button_up() -> void:
	is_dragging = false
	if hex_grid:
		clear_marker()
		spawn_marker()
	else:
		print("Grid não encontrada!")

func spawn_marker() -> void:
	var surround = hex_grid.get_surrounding_cells(hex_grid.local_to_map(global_position))
	for pos in surround:
		print("Posição do vizinho %s: %s" % [pos, hex_grid.map_to_local(pos)])
		var new_marker = GRID_MARKER.instantiate()
		new_marker.global_position = hex_grid.map_to_local(pos)
		$"../GridMarkers".add_child(new_marker)

func clear_marker() -> void:
	var child = $"../GridMarkers".get_children()
	for i in child:
		i.queue_free()


func _on_button_mouse_entered() -> void:
	san_bar.show()
	postura_bar.show()
	$Token/Bars.position.y -=30


func _on_button_mouse_exited() -> void:
	san_bar.hide()
	postura_bar.hide()
	$Token/Bars.position.y +=30
