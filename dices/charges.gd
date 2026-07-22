extends Control

var amount := 0
var value := 0
var crit := 0
var type = ""

var charge_instances = []

const CHARGE = preload("res://dices/charge_instance.tscn")

@onready var grid_container: GridContainer = $Panel/GridContainer
@onready var label: Label = $Label

func _ready() -> void:
	final_value = 0
	times = 0
	custom_minimum_size.x = 86 * amount
	label.custom_minimum_size.x = 86 * amount
	for i in range(amount):
		var new_charge_instance = CHARGE.instantiate()
		charge_instances.append(new_charge_instance)
		grid_container.add_child(new_charge_instance)
		new_charge_instance.final_value.connect(_get_final_value)
		
		var rng = randi_range(1, 6)
		new_charge_instance.value = value
		new_charge_instance.type = type
		new_charge_instance.set_animation(rng)
		await get_tree().create_timer(1).timeout


func _on_timer_timeout() -> void:
	queue_free()

@export var final_value = 0
var times = 0

func _get_final_value(new_value, new_crit) -> void:
	times += 1
	final_value += new_value
	label.text = str(final_value)
	if times == amount:
		label.add_theme_font_size_override("font_size", 32)
		if type == "Polus":
			label.modulate = Color("#ff9900")
		else:
			label.modulate = Color("#ff0000")
