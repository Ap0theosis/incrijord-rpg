extends Node2D

@onready var label_2: Label = $VBoxContainer/Label2

func _ready() -> void:
	global_position.y -= 150
	roll_d20()

func roll_d20() -> void:
	for i in range(10):
		var rng = randi_range(1, 20)
		label_2.text = str(rng)
		await get_tree().create_timer(0.1).timeout
	

func _on_button_pressed() -> void:
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
