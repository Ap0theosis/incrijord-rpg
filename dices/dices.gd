extends Control

@onready var result_label: Label = $VBoxContainer/ResultLabel
@onready var type_label: Label = $VBoxContainer/TypeLabel
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var panel: Panel = $Panel
@onready var multiplayer_synchronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer

var type = ""

const DICES = preload("res://dices/dices.tscn")

func _ready() -> void:
	type_label.text = type
	match type:
		"D6":
			roll_d6()
		"D20":
			roll_d20()

func roll_d20() -> void:
	for i in range(10):
		var rng = randi_range(1, 20)
		result_label.text = str(rng)
		await get_tree().create_timer(0.1).timeout

func roll_d6() -> void:
	for i in range(10):
		var rng = randi_range(1, 6)
		result_label.text = str(rng)
		await get_tree().create_timer(0.1).timeout

func _on_button_pressed() -> void:
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()
