extends Node2D

var parent = null

@onready var hex_grid: TileMapLayer = $"../../TileMapLayer"
@onready var grid_markers: Node2D = $"../../GridMarkers"

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() != parent:
		queue_free()
