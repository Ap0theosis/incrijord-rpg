extends Node2D

var parent = null
var target = null
var power = 0

@onready var target_markers: Node2D = $".."

func _on_button_pressed() -> void:
	if target:
		if target.has_method("take_damage"):
			target.take_damage(power)
	for i in target_markers.get_children():
		i.queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	target = area.get_parent()
