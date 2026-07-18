extends Node2D

@onready var hex_grid: TileMapLayer = $TileMapLayer

#@onready var roll_20: Button = $HUD/MarginContainer/DiceContainer/Roll20
#@onready var roll_6: Button = $HUD/MarginContainer/DiceContainer/Roll6


@onready var ficha_container: PanelContainer = $HUD/FichaContainer
@onready var close_target_button: Button = $HUD/EditCloseContainer/CloseTarget

@onready var mouse_pos_label: Label = $HUD/MarginContainer2/MousePosLabel
@onready var tokens_node: Node2D = $Tokens

@onready var time_label: RichTextLabel = $HUD/MarginContainer2/VBoxContainer/HBoxContainer/TimeLabel
@onready var change_time_toggle: Button = $HUD/MarginContainer2/VBoxContainer/HBoxContainer2/ChangeTimeButton
@onready var region_option_button: OptionButton = $HUD/MarginContainer2/VBoxContainer/HBoxContainer/OptionButton
@onready var choose_time_button: SpinBox = $HUD/MarginContainer2/VBoxContainer/HBoxContainer2/ChooseTimeButton
@onready var region_label: RichTextLabel = $HUD/MarginContainer2/VBoxContainer/HBoxContainer/RegionLabel
@onready var time_options: HBoxContainer = $HUD/MarginContainer2/VBoxContainer/HBoxContainer2

@onready var EDIT_LINES =[
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
	$HUD/EditCloseContainer/ColorPickerButton,
	$HUD/EditCloseContainer/UploadButton
]

@onready var dice_container: PanelContainer = $HUD/DiceContainer
@onready var zoom_container: PanelContainer = $HUD/ZoomContainer
@onready var vantagem_spinbox: SpinBox = $HUD/DiceContainer/VboxContainer/VantagemContainer/VantagemSpinbox
@onready var bonus_spinbox: SpinBox = $HUD/DiceContainer/VboxContainer/BonusContainer/BonusSpinbox
@onready var secret_dice_toggle: CheckButton = $HUD/DiceContainer/VboxContainer/SecretContainer/SecretDiceToggle
@onready var mestre_button: Button = $HUD/MenuContainer/VBoxContainer/MestreButton
@onready var iniciativa_button: Button = $HUD/MenuContainer/VBoxContainer/IniciativaButton
@onready var color_picker_button: ColorPickerButton = $HUD/EditCloseContainer/ColorPickerButton


enum REGIONS {Gama, Tiamatia, Svenia, Magilith, Rubiavéu, Yamagon, Breu, Levorith, MundoHumano, Nartá, X}
var zoom = 100
var selected = null
var time = 0
var day_night = false
var editing = false

func _ready() -> void:
	if OS.has_feature("web_android"):
		$HUD/MarginContainer2/VirtualJoystick.show()
	if not multiplayer.is_server():
		region_option_button.hide()
		choose_time_button.hide()
		time_options.hide()
		mestre_button.hide()

func _process(_delta: float) -> void:
	mouse_pos_label.text = str(hex_grid.local_to_map(get_global_mouse_position()))

func _on_selected_token(id) -> void:
	$HUD/VBoxContainer.show()
	$HUD/EditCloseContainer.show()
	editing = false
	for edit in EDIT_LINES:
		edit.hide()

	
	for child in $Tokens.get_children():
		if child.name != id:
			child.selected = false
			child.update_hud()
		else:
			selected = child
	
	definir_ficha()
	ficha_container.show()
	
	

func _on_selected_attack_button_down() -> void:
	if selected:
		selected.attack()

func _on_target_reset_pressed() -> void:
	$HUD/VBoxContainer.hide()
	$HUD/EditCloseContainer.hide()
	ficha_container.hide()
	
	for child in $Tokens.get_children():
		child.selected = false
		child.update_hud()
	for child in $TargetMarkers.get_children():
		child.queue_free()
	selected = null


@onready var ficha_name: Label = $HUD/FichaContainer/Margin/Geral/VBoxContainer/HBoxContainer/Name
@onready var ficha_rank: Label = $HUD/FichaContainer/Margin/Geral/VBoxContainer/Rank
@onready var ficha_icon: TextureRect = $HUD/FichaContainer/Margin/Geral/VBoxContainer/ImageContainer/Icon
@onready var ficha_race: Label = $HUD/FichaContainer/Margin/Geral/VBoxContainer/Race
@onready var ficha_foco: Label = $HUD/FichaContainer/Margin/Geral/VBoxContainer/Focus
@onready var ficha_aspiration: Label = $HUD/FichaContainer/Margin/Geral/VBoxContainer/Aspiration
@onready var ficha_aspecto: Label = $HUD/FichaContainer/Margin/Geral/VBoxContainer/AspectContainer/Label2
@onready var ficha_alma: Label = $HUD/FichaContainer/Margin/Geral/VBoxContainer/AlmaContainer/Label2
@onready var ficha_fobia: Label = $HUD/FichaContainer/Margin/Geral/VBoxContainer/FobiaContainer/Label2
@onready var ficha_credits: Label = $HUD/FichaContainer/Margin/Geral/VBoxContainer/CreditsContainer/CreditsValue
@onready var ficha_limit: Label = $HUD/FichaContainer/Margin/Geral/VBoxContainer/CreditsContainer/CreditsLimit
@onready var ficha_morte: Label = $HUD/FichaContainer/Margin/Geral/VBoxContainer/MorteContainer/Value
@onready var ficha_max_morte: Label = $HUD/FichaContainer/Margin/Geral/VBoxContainer/MorteContainer/Max
@onready var ficha_medo: Label = $HUD/FichaContainer/Margin/Geral/VBoxContainer/MedoContainer/Value
@onready var ficha_max_medo: Label = $HUD/FichaContainer/Margin/Geral/VBoxContainer/MedoContainer/Max
@onready var ficha_vida: Label = $HUD/FichaContainer/Margin/Geral/VBoxContainer/VidaContainer/Value
@onready var ficha_max_vida: Label = $HUD/FichaContainer/Margin/Geral/VBoxContainer/VidaContainer/Max
@onready var ficha_vidatemp: Label = $HUD/FichaContainer/Margin/Geral/VBoxContainer/TempContainer/Value
@onready var ficha_max_vidatemp: Label = $HUD/FichaContainer/Margin/Geral/VBoxContainer/TempContainer/Max
@onready var ficha_sanidade: Label = $HUD/FichaContainer/Margin/Geral/VBoxContainer/SanContainer/Value
@onready var ficha_max_sanidade: Label = $HUD/FichaContainer/Margin/Geral/VBoxContainer/SanContainer/Max
@onready var ficha_postura: Label = $HUD/FichaContainer/Margin/Geral/VBoxContainer/PosContainer/Value
@onready var ficha_max_postura: Label = $HUD/FichaContainer/Margin/Geral/VBoxContainer/PosContainer/Max
@onready var ficha_resist_fisica: Label = $HUD/FichaContainer/Margin/Geral/VBoxContainer/ResContainer/Value
@onready var ficha_resist_magica: Label = $HUD/FichaContainer/Margin/Geral/VBoxContainer/ResContainer/Value2

func definir_ficha() -> void:
	color_picker_button.color = selected.token_texture.self_modulate
	if selected.stats:
		ficha_name.text = selected.stats["name"]
		ficha_rank.text = "Rank " + selected.stats["rank"]
		ficha_icon.texture = selected.stats["icon"]
		ficha_race.text = selected.stats["race"]
		ficha_foco.text = selected.stats["foco"]
		ficha_aspiration.text = selected.stats["aspiration"]
		ficha_aspecto.text = selected.stats["aspecto"]
		ficha_alma.text = selected.stats["alma"]
		ficha_fobia.text = selected.stats["fobia"]
		ficha_credits.text = str(selected.stats["credits"])
		ficha_limit.text = str(selected.stats["limit"])
		ficha_morte.text = str(selected.stats["morte"])
		ficha_max_morte.text = str(selected.stats["max_morte"])
		ficha_medo.text = str(selected.stats["medo"])
		ficha_max_medo.text = str(selected.stats["max_medo"])
		ficha_vida.text = str(selected.stats["vida"])
		ficha_max_vida.text = str(selected.stats["max_vida"])
		ficha_vidatemp.text = str(selected.stats["vidatemp"])
		ficha_max_vidatemp.text = str(selected.stats["max_vidatemp"])
		ficha_sanidade.text = str(selected.stats["sanidade"])
		ficha_max_sanidade.text = str(selected.stats["max_sanidade"])
		ficha_postura.text = str(selected.stats["postura"])
		ficha_max_postura.text = str(selected.stats["max_postura"])
		ficha_resist_fisica.text = str(selected.stats["resist_fisica"])
		ficha_resist_magica.text = str(selected.stats["resist_magica"])


var dice_advantage = 0
var dice_bonus = 0
var dice_secret = false

func _on_roll_pressed(dice: String) -> void:
	if selected:
		selected.spawn_dice.rpc(dice, dice_advantage, dice_bonus, dice_secret)

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

func _on_color_picker_button_color_changed(color: Color) -> void:
	if selected:
		selected.apply_hex_color(color)


func _on_vida_edit_text_submitted(new_text: String) -> void:
	var token_id = selected.stats["id"]
	TokensData.players[token_id]["vida"] = int(new_text)
	print("Nova vida: " + str(TokensData.players[token_id]["vida"]))
	selected.update_hud.rpc()
	definir_ficha()
