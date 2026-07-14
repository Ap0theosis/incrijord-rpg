extends Node2D

@onready var camera = $Camera2D
@onready var zoom_value: Label = $"../../HUD/MarginContainer/HBoxContainer/ZoomValue"
var zoom = 100
var zoom_speed_mult = 1.0
const SPEED = 1000

@export var player_id := 1:
	set(id):
		player_id = id

func _ready():
	set_multiplayer_authority(name.to_int())
	if is_multiplayer_authority():
		camera.make_current()

func _process(delta):
	if not is_multiplayer_authority():
		return
		
	var cam_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if cam_direction:
		camera.global_position += cam_direction * delta * SPEED * zoom_speed_mult
	
	if Input.is_action_just_pressed("zoom_in"):
		if zoom < 250:
			zoom += 5
			zoom_speed_mult /= 1.05
			zoom_value.text = str(str(zoom) + "%")
			camera.zoom.x += 0.05 
			camera.zoom.y += 0.05
	
	if Input.is_action_just_pressed("zoom_out"):
		if zoom > 25:
			zoom -= 5
			zoom_speed_mult *= 1.05
			zoom_value.text = str(str(zoom) + "%")
			camera.zoom.x -= 0.05 
			camera.zoom.y -= 0.05  
