extends Node2D

@onready var camera = $Camera2D
@onready var zoom_value: Label = $"../../HUD/ZoomContainer/HBoxContainer/ZoomValue"
@onready var zoom_reset: Button = $"../../HUD/ZoomContainer/HBoxContainer/ZoomReset"
@onready var zoom_scroll_bar: HScrollBar = $"../../HUD/ZoomContainer/HBoxContainer/ZoomScrollBar"


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
	
	zoom_reset.pressed.connect(_on_zoom_reset_pressed)
	zoom_scroll_bar.value_changed.connect(_on_zoom_scroll_bar_value_changed)

func _process(delta):
	if not is_multiplayer_authority():
		return
	if $"../../HUD/FichaContainer".editing:
		return
	var cam_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if cam_direction:
		camera.global_position += cam_direction * delta * SPEED * zoom_speed_mult
	
	if Input.is_action_just_pressed("zoom_in"):
		if zoom < 250:
			zoom += 5
			zoom_scroll_bar.value += 5
			zoom_value.text = str(str(zoom) + "%")
			camera.zoom.x += 0.05 
			camera.zoom.y += 0.05
	
	if Input.is_action_just_pressed("zoom_out"):
		if zoom > 25:
			zoom -= 5
			zoom_scroll_bar.value -= 5
			zoom_value.text = str(str(zoom) + "%")
			camera.zoom.x -= 0.05 
			camera.zoom.y -= 0.05  

func _on_zoom_reset_pressed() -> void:
	camera.zoom = Vector2(1.0, 1.0)
	zoom = 100
	zoom_speed_mult = 1.0
	zoom_value.text = str(str(zoom) + "%")
	zoom_scroll_bar.value = 100

func _on_zoom_scroll_bar_value_changed(value: float) -> void:
	zoom = int(value)
	zoom_value.text = str(str(zoom) + "%")
	var value_decimal = (value / 100)
	if value > 100:
		zoom_speed_mult = 0.75
	if value < 100:
		zoom_speed_mult = 1.5
	camera.zoom = Vector2(value_decimal, value_decimal)
