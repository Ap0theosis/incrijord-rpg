extends Node2D

@onready var hex_grid: TileMapLayer = $TileMapLayer

#@onready var roll_20: Button = $HUD/MarginContainer/DiceContainer/Roll20
#@onready var roll_6: Button = $HUD/MarginContainer/DiceContainer/Roll6


@onready var ficha_container: PanelContainer = $HUD/FichaContainer
@onready var selected_name: Label = $HUD/FichaContainer/Margin/Geral/VBoxContainer/HBoxContainer/Name
@onready var target_reset_button: Button = $HUD/VBoxContainer/TargetReset

@onready var mouse_pos_label: Label = $HUD/MarginContainer2/MousePosLabel
@onready var tokens_node: Node2D = $Tokens

@onready var time_label: RichTextLabel = $HUD/MarginContainer2/VBoxContainer/HBoxContainer/TimeLabel
@onready var change_time_toggle: Button = $HUD/MarginContainer2/VBoxContainer/HBoxContainer2/ChangeTimeButton
@onready var region_option_button: OptionButton = $HUD/MarginContainer2/VBoxContainer/HBoxContainer/OptionButton
@onready var choose_time_button: SpinBox = $HUD/MarginContainer2/VBoxContainer/HBoxContainer2/ChooseTimeButton
@onready var region_label: RichTextLabel = $HUD/MarginContainer2/VBoxContainer/HBoxContainer/RegionLabel
@onready var time_options: HBoxContainer = $HUD/MarginContainer2/VBoxContainer/HBoxContainer2

@onready var EDIT_LINES =[
	$HUD/FichaContainer/Margin/Geral/VBoxContainer/HBoxContainer/NameEdit,
	$HUD/FichaContainer/Margin/Geral/VBoxContainer/AlmaContainer/AlmaEdit,
	$HUD/FichaContainer/Margin/Geral/VBoxContainer/FobiaContainer/FobiaEdit,
	$HUD/FichaContainer/Margin/Geral/VBoxContainer/CreditsContainer/CreditsValueEdit,
	$HUD/FichaContainer/Margin/Geral/VBoxContainer/CreditsContainer/CreditsLimitEdit,
	$HUD/FichaContainer/Margin/Geral/VBoxContainer/MorteContainer/MorteEdit,
	$HUD/FichaContainer/Margin/Geral/VBoxContainer/MorteContainer/MorteMaxEdit,
	$HUD/FichaContainer/Margin/Geral/VBoxContainer/MedoContainer/MedoEdit,
	$HUD/FichaContainer/Margin/Geral/VBoxContainer/MedoContainer/MedoMaxEdit,
	$HUD/FichaContainer/Margin/Geral/VBoxContainer/VidaContainer/VidaEdit,
	$HUD/FichaContainer/Margin/Geral/VBoxContainer/VidaContainer/VidaMaxEdit,
	$HUD/FichaContainer/Margin/Geral/VBoxContainer/TempContainer/VTempEdit,
	$HUD/FichaContainer/Margin/Geral/VBoxContainer/TempContainer/VTempMaxEdit,
	$HUD/FichaContainer/Margin/Geral/VBoxContainer/SanContainer/SanEdit,
	$HUD/FichaContainer/Margin/Geral/VBoxContainer/SanContainer/SanMaxEdit,
	$HUD/FichaContainer/Margin/Geral/VBoxContainer/PosContainer/PosEdit,
	$HUD/FichaContainer/Margin/Geral/VBoxContainer/PosContainer/PosMaxEdit,
	$HUD/FichaContainer/Margin/Geral/ImageEditContainer
]

@onready var dice_container: PanelContainer = $HUD/DiceContainer
@onready var zoom_container: PanelContainer = $HUD/ZoomContainer
@onready var vantagem_spinbox: SpinBox = $HUD/DiceContainer/VboxContainer/VantagemContainer/VantagemSpinbox
@onready var bonus_spinbox: SpinBox = $HUD/DiceContainer/VboxContainer/BonusContainer/BonusSpinbox
@onready var secret_dice_toggle: CheckButton = $HUD/DiceContainer/VboxContainer/SecretContainer/SecretDiceToggle

var zoom = 100
var selected = null
enum REGIONS {Gama, Tiamatia, Svenia, Magilith, Rubiavéu, Yamagon, Breu, Levorith, MundoHumano, Nartá}
var time = 0
var day_night = false
var editing = false

func _ready() -> void:
	if OS.has_feature("web_android"):
		$HUD/VirtualJoystick.show()
	if not multiplayer.is_server():
		region_option_button.hide()
		choose_time_button.hide()
		time_options.hide()
	
	selected_name.text = "Nenhum Alvo"

func _process(_delta: float) -> void:
	mouse_pos_label.text = str(hex_grid.local_to_map(get_global_mouse_position()))


func _on_selected_token(id) -> void:
	$HUD/VBoxContainer.show()
	ficha_container.show()
	
	for child in $Tokens.get_children():
		if child.name != id:
			child.selected = false
			child.update_hud()
		else:
			selected = child
			selected_name.text = selected.stats["name"]

func _on_selected_attack_button_down() -> void:
	if selected:
		selected.attack()

func _on_target_reset_pressed() -> void:
	$HUD/VBoxContainer.hide()
	ficha_container.hide()
	
	for child in $Tokens.get_children():
		child.selected = false
		child.update_hud()
	for child in $TargetMarkers.get_children():
		child.queue_free()
	selected = null
	selected_name.text = "Nenhum Alvo"

var dice_advantage = 0
var dice_bonus = 0
var dice_secret = false

func _on_roll_20_pressed() -> void:
	if selected:
		selected.spawn_dice.rpc("D20", dice_advantage, dice_bonus, dice_secret)

func _on_roll_6_pressed() -> void:
	if selected:
		selected.spawn_dice.rpc("D6", dice_advantage, dice_bonus, dice_secret)

func set_region(region: int):
	region_label.text = REGIONS.find_key(region)
	for child in tokens_node.get_children():
		child.in_region = REGIONS.find_key(region)

func _on_choose_time_button_value_changed(value: int) -> void:
	time = value
	if day_night:
		if time > 4 and time < 18:
			time_label.text = "Dia"
		else:
			time_label.text = "Noite"
		return
	time_label.text = str(value) + ":00"


func _on_change_time_button_toggled(toggled_on: bool) -> void:
	day_night = toggled_on


func _on_visible_time_button_toggled(toggled_on: bool) -> void:
	time_label.visible = toggled_on


func _on_edit_button_pressed() -> void:
	if not editing:
		editing = true
		for edit in EDIT_LINES:
			edit.show()
	else:
		editing = false
		for edit in EDIT_LINES:
			edit.hide()


func _on_dados_button_toggled(toggled_on: bool) -> void:
	dice_container.visible = toggled_on

func _on_camera_button_toggled(toggled_on: bool) -> void:
	zoom_container.visible = toggled_on

func _on_secret_dice_toggled(toggled_on: bool) -> void:
	dice_secret = toggled_on

func _on_bonus_spinbox_value_changed(value: float) -> void:
	dice_bonus = value

func _on_vantagem_spinbox_value_changed(value: float) -> void:
	dice_advantage = value
