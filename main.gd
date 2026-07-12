extends Node2D

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var allace: Node2D = $Allace

@onready var zoom_out: Button = $HUD/MarginContainer/HBoxContainer/ZoomOut
@onready var zoom_in: Button = $HUD/MarginContainer/HBoxContainer/ZoomIn
@onready var zoom_value: Label = $HUD/MarginContainer/HBoxContainer/ZoomValue
@onready var camera: Camera2D = $Camera

var zoom = 100

func _process(delta: float) -> void:
	var allace_coor = tile_map_layer.local_to_map(allace.global_position)
	if not allace.is_dragging:
		allace.global_position = tile_map_layer.map_to_local(allace_coor)
	
	if Input.is_action_just_pressed("zoom_in"):
		if zoom < 250:
			zoom += 5
			zoom_value.text = str(str(zoom) + "%")
			camera.zoom.x += 0.05 
			camera.zoom.y += 0.05
		
	if Input.is_action_just_pressed("zoom_out"):
		if zoom > 25:
			zoom -= 5
			zoom_value.text = str(str(zoom) + "%")
			camera.zoom.x -= 0.05 
			camera.zoom.y -= 0.05  




func _on_zoom_out_pressed() -> void:
	if zoom > 25:
		camera.zoom -= Vector2(0.25, 0.25)
		zoom -= 25
		zoom_value.text = str(str(zoom) + "%")

func _on_zoom_in_pressed() -> void:
	if zoom < 250:
		camera.zoom += Vector2(0.25, 0.25)
		zoom += 25
		zoom_value.text = str(str(zoom) + "%")


func _on_zoom_reset_pressed() -> void:
	camera.zoom = Vector2(1, 1)
	zoom = 100
	zoom_value.text = str(str(zoom) + "%")
