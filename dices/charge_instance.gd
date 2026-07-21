extends Control

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var value = 0
var type = ""
var crit = 0

signal final_value(value, crit)

func set_animation(rng):
	match rng:
		1:
			animated_sprite_2d.play("%s_fail" % type)
			value = 0
		2:
			animated_sprite_2d.play("%s_normal" % type)
		3:
			animated_sprite_2d.play("%s_normal" % type)
		4:
			animated_sprite_2d.play("%s_normal" % type)
		5:
			animated_sprite_2d.play("%s_normal" % type)
		6:
			animated_sprite_2d.play("%s_crit" % type)
			crit = 1

func _on_button_pressed() -> void:
	get_parent().get_parent().get_parent().queue_free()

func _on_animated_sprite_2d_animation_finished() -> void:
	final_value.emit(value, crit)
