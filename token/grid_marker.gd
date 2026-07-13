extends Node2D

var parent = null

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().name != parent:
		queue_free()
