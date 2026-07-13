extends Node2D

@onready var hex_grid: TileMapLayer = $TileMapLayer

@onready var zoom_out: Button = $HUD/MarginContainer/HBoxContainer/ZoomOut
@onready var zoom_in: Button = $HUD/MarginContainer/HBoxContainer/ZoomIn
@onready var zoom_value: Label = $HUD/MarginContainer/HBoxContainer/ZoomValue
@onready var roll_20: Button = $HUD/MarginContainer/DiceContainer/Roll20
@onready var roll_6: Button = $HUD/MarginContainer/DiceContainer/Roll6
@onready var selected_name: Label = $HUD/MarginContainer/VBoxContainer/SelectedName
@onready var mouse_pos_label: Label = $HUD/MarginContainer2/MousePosLabel


var zoom = 100
var selected = null

const DICES = preload("res://dices/dices.tscn")

func _process(delta: float) -> void:
	mouse_pos_label.text = str(hex_grid.local_to_map(get_global_mouse_position()))

func _on_zoom_out_pressed() -> void:
	if zoom > 25:
		#camera.zoom -= Vector2(0.25, 0.25)
		zoom -= 25
		zoom_value.text = str(str(zoom) + "%")

func _on_zoom_in_pressed() -> void:
	if zoom < 250:
		#camera.zoom += Vector2(0.25, 0.25)
		zoom += 25
		zoom_value.text = str(str(zoom) + "%")

func _on_zoom_reset_pressed() -> void:
	#camera.zoom = Vector2(1, 1)
	zoom = 100
	zoom_value.text = str(str(zoom) + "%")

func _on_roll_20_pressed() -> void:
	var new_dice = DICES.instantiate()
	if selected:
		new_dice.global_position.y -= 150
		selected.add_child(new_dice)
		return
	#new_dice.global_position = camera.global_position
	get_tree().current_scene.add_child(new_dice)

func _on_roll_6_pressed() -> void:
	var new_dice = DICES.instantiate()
	#new_dice.global_position = camera.global_position
	if selected:
		new_dice.global_position = selected.global_position
		new_dice.global_position.y -= 200 
	get_tree().current_scene.add_child(new_dice)

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

func _on_target_reset_pressed() -> void:
	for child in $Tokens.get_children():
		child.selected = false
		child.update_hud()
	selected = null
	selected_name.text = "Nenhum Alvo"
