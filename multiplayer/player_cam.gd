extends Node2D

@onready var camera = $Camera2D
var zoom = 100

@export var player_id := 1:
	set(id):
		player_id = id

func _ready():
	# Define quem manda nesta câmera com base no nome do nó (ID da rede)
	set_multiplayer_authority(name.to_int())
	
	# Se for a MINHA câmera, eu ativo ela. Se for do outro, desativo para não dar conflito
	if is_multiplayer_authority():
		camera.make_current()

func _process(delta):
	if not is_multiplayer_authority():
		return
		
	var cam_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if cam_direction:
		camera.global_position += cam_direction * delta * 700
	
	if Input.is_action_just_pressed("zoom_in"):
		if zoom < 250:
			zoom += 5
			#zoom_value.text = str(str(zoom) + "%")
			camera.zoom.x += 0.05 
			camera.zoom.y += 0.05
	
	if Input.is_action_just_pressed("zoom_out"):
		if zoom > 25:
			zoom -= 5
			#zoom_value.text = str(str(zoom) + "%")
			camera.zoom.x -= 0.05 
			camera.zoom.y -= 0.05  
