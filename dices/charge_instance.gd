extends Control

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var value = 0
var type = ""

func set_animation(rng):
	match rng:
		1:
			animated_sprite_2d.play("%s_fail" % type)
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


func _on_button_pressed() -> void:
	get_parent().get_parent().get_parent().queue_free()
