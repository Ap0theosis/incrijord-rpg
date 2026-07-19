extends Control
const PLAYER_CAM = preload("res://multiplayer/player_cam.tscn")
var spawn_node = null

func _ready() -> void:
	$VBoxContainer/IpLabel.text = Rede.ADDRESS

func _on_host_pressed():
	Rede.criar_host()

func _on_join_pressed():
	Rede.conectar_ao_host()


func _on_single_player_pressed() -> void:
	Rede.single_player()

func _on_line_edit_text_submitted(new_text: String) -> void:
	Rede.ADDRESS = new_text
	$VBoxContainer/IpLabel.text = Rede.ADDRESS
