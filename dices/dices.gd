extends Control

@onready var type_label: Label = $Panel/VBoxContainer/TypeLabel
@onready var rng_label: Label = $Panel/VBoxContainer/RngLabel
@onready var bonus_label: Label = $Panel/VBoxContainer/BonusLabel
@onready var result_label: Label = $Panel/VBoxContainer/ResultLabel

var type = ""
var bonus : int = 0
var secret = false

func _ready() -> void:
	type_label.text = type
	get_parent().position.y = -212
	get_parent().position.x = -230
	if bonus:
		get_parent().position.y = -252
		bonus_label.show()
	match type:
		"D4":
			roll(4)
		"D6":
			roll(6)
		"D8":
			roll(8)
		"D10":
			roll(10)
		"D20":
			roll(20)
		"D100":
			roll(100)

func roll(dicetype) -> void:
	var result = 0
	var rng = "..."
	bonus_label.text = str(bonus)
	if bonus > 0:
		bonus_label.modulate = Color(0.31, 0.699, 0.345, 1.0)
	else:
		bonus_label.modulate = Color(1.0, 0.337, 0.349, 1.0)
	for i in range(10):
		rng = randi_range(1, dicetype)
		rng_label.text = str(rng)
		await get_tree().create_timer(0.1).timeout
	rng_label.modulate = Color(0.576, 0.148, 1.0, 1.0)
	result = rng + bonus
	result_label.text = str(result) 

func _on_button_pressed() -> void:
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()
