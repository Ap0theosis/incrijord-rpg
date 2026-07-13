extends Node2D

@onready var tile_map_layer: TileMapLayer = $TileMapLayer

@onready var zoom_out: Button = $HUD/MarginContainer/HBoxContainer/ZoomOut
@onready var zoom_in: Button = $HUD/MarginContainer/HBoxContainer/ZoomIn
@onready var zoom_value: Label = $HUD/MarginContainer/HBoxContainer/ZoomValue
@onready var camera: Camera2D = $Camera
@onready var dice_result: Label = $HUD/MarginContainer/DiceContainer/Result
@onready var roll_20: Button = $HUD/MarginContainer/DiceContainer/Roll20
@onready var roll_6: Button = $HUD/MarginContainer/DiceContainer/Roll6
@onready var selected_name: Label = $HUD/MarginContainer/VBoxContainer/SelectedName


var zoom = 100
var selected = null

func _process(delta: float) -> void:
	var cam_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if cam_direction:
		camera.global_position += cam_direction * delta * 700
	
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

func _on_roll_20_pressed() -> void:
	var rng = randi_range(1, 20)
	dice_result.text = str(rng)

func _on_roll_6_pressed() -> void:
	var rng = randi_range(1, 6)
	dice_result.text = str(rng)

func _on_selected_token(id) -> void:
	for child in $Tokens.get_children():
		if child.name != id:
			child.selected = false
			child.update_hud()
		else:
			selected = child
			selected_name.text = selected.token_name


func _on_selected_attack_button_down() -> void:
	selected.attack()
