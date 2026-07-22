extends Control


@onready var galvan: Control = $TabContainer/Raça/Galvan
@onready var vampiro: Control = $TabContainer/Raça/Vampiro
@onready var ficha_container: PanelContainer = $"../FichaContainer"
@onready var edit_close_container: VBoxContainer = $"../EditCloseContainer"
@onready var ficha_menu_container: VBoxContainer = $"../FichaMenuContainer"
@onready var race_title: RichTextLabel = $TabContainer/Raça/RaceTitle

@onready var races = {
	"Galvan" = {
		"node" = galvan,
		"color" = "9900ff"
		},
	"Vampiro" = {
		"node" = vampiro,
		"color" = "ff0000"
		},
}

var token = null

func _ready() -> void:
	var token_race = token.stats.raca
	races[token_race]["node"].show()
	print(races[token_race])
	race_title.text = "[b][color=%s] %s" % [races[token_race]["color"], token_race]


func _on_button_pressed() -> void:
	ficha_container.show()
	edit_close_container.show()
	ficha_menu_container.show()
	queue_free()
