extends Control

var amount := 0
var value := 0
var crit := 0
var type = ""

var charge_instances = []

const CHARGE = preload("res://dices/charge_instance.tscn")

@onready var grid_container: GridContainer = $Panel/GridContainer

func _ready() -> void:
	custom_minimum_size.x = 86 * amount
	for i in range(amount):
		var new_charge_instance = CHARGE.instantiate()
		charge_instances.append(new_charge_instance)
		grid_container.add_child(new_charge_instance)
		
		var rng = randi_range(1, 6)
		new_charge_instance.value = rng
		new_charge_instance.type = type
		new_charge_instance.set_animation(rng)


func _on_timer_timeout() -> void:
	queue_free()
