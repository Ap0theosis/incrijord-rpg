extends Node2D

@onready var hex_grid: TileMapLayer = $TileMapLayer

@onready var ficha_container: PanelContainer = $HUD/FichaContainer
@onready var close_target_button: Button = $HUD/EditCloseContainer/CloseTarget
@onready var virtual_joystick: VirtualJoystick = $HUD/MarginContainer2/VirtualJoystick

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
	$HUD/FichaContainer/Margin/Geral/VBoxContainer/ResContainer/ResFEdit, 
	$HUD/FichaContainer/Margin/Geral/VBoxContainer/ResContainer/ResMEdit,
	$HUD/EditCloseContainer/ColorPickerButton,
	$HUD/EditCloseContainer/UploadButton,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/CorpoContainer/CorpoEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/DestrezaContainer/DestrezaEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/MenteContainer/MenteEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/EspiritoContainer/EspiritoEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/CarismaContainer/CarismaEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/PurificacaoContainer/PurificacaoEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/IlusaoContainer/IlusaoEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/SeloContainer/SeloEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/BencaoMaldicaoContainer/BencaoMaldicaoEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/ConjuracaoContainer/ConjuracaoEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/ClarividenciaContainer/ClarividenciaEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/SobrecargaContainer/SobrecargaEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/FurtividadeContainer/FurtividadeEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/PrestidigitacaoContainer/PrestidigitacaoEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/InstintoContainer/InstintoEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/AcrobaciaContainer/AcrobaciaEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/AtletismoContainer/AtletismoEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/AdrenalinaContainer/AdrenalinaEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/RigidezContainer/RigidezEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/IntimidacaoContainer/IntimidacaoEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/ArtesContainer/ArtesEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/PersuasaoContainer/PersuasaoEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/PerspicaciaContainer/PerspicaciaEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/LidarCriaturasContainer/LidarCriaturasEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/EncorajarContainer/EncorajarEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/EncantarContainer/EncantarEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/AparelhagemContainer/AparelhagemEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/MedicinaContainer/MedicinaEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/GastronomiaContainer/GastronomiaEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/InvestigacaoContainer/InvestigacaoEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/CriaçãoContainer/CriaçãoEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/CoragemContainer/CoragemEdit,
	$HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/SobrevivenciaContainer/SobrevivenciaEdit
]

@onready var dice_container: PanelContainer = $HUD/DiceContainer
@onready var zoom_container: PanelContainer = $HUD/ZoomContainer
@onready var vantagem_spinbox: SpinBox = $HUD/DiceContainer/VboxContainer/VantagemContainer/VantagemSpinbox
@onready var bonus_spinbox: SpinBox = $HUD/DiceContainer/VboxContainer/BonusContainer/BonusSpinbox
@onready var secret_dice_toggle: CheckButton = $HUD/DiceContainer/VboxContainer/SecretContainer/SecretDiceToggle
@onready var mestre_button: Button = $HUD/MenuContainer/VBoxContainer/MestreButton
@onready var iniciativa_button: Button = $HUD/MenuContainer/VBoxContainer/IniciativaButton

@onready var ficha_menu_container: VBoxContainer = $HUD/FichaMenuContainer


enum REGIONS {Gama, Tiamatia, Svenia, Magilith, Rubiavéu, Yamagon, Breu, Levorith, MundoHumano, Nartá, X}
var zoom = 100
var selected = null
var time = 0
var day_night = false
var editing = false

@export var free_movement = false
var iniciativa = {}

func _ready() -> void:
	$HUD/EditCloseContainer.hide()
	ficha_container.hide()
	ficha_menu_container.hide()
	
	if OS.has_feature("web_android") or OS.has_feature("mobile"):
		virtual_joystick.show()
	if not multiplayer.is_server():
		region_option_button.hide()
		choose_time_button.hide()
		time_options.hide()
		mestre_button.hide()

func _on_selected_attack_button_down() -> void:
	if selected:
		selected.attack()

func _on_target_reset_pressed() -> void:
	ficha_menu_container.hide()
	$HUD/EditCloseContainer.hide()
	ficha_container.hide()
	
	for child in $Tokens.get_children():
		child.selected = false
		child.update_hud()
	for child in $TargetMarkers.get_children():
		child.queue_free()
	selected = null

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

@onready var geral_button: Button = $HUD/FichaMenuContainer/GeralButton
@onready var atributos_button: Button = $HUD/FichaMenuContainer/AtributosButton

@onready var ficha_geral: Control = $HUD/FichaContainer/Margin/Geral
@onready var ficha_atributos: Control = $HUD/FichaContainer/Margin/Atributos
@onready var ficha_habilidades: Control = $HUD/FichaContainer/Margin/Habilidades

func _on_atributos_button_toggled(toggled_on: bool) -> void:
	ficha_atributos.visible = toggled_on

func _on_geral_button_toggled(toggled_on: bool) -> void:
	ficha_geral.visible = toggled_on

func _on_habilidades_button_toggled(toggled_on: bool) -> void:
	ficha_habilidades.visible = toggled_on

@onready var fisico_container: VBoxContainer = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer
@onready var social_container: VBoxContainer = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer
@onready var mental_container: VBoxContainer = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer
@onready var espiritual_container: VBoxContainer = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer

func _on_fisico_button_toggled(toggled_on: bool) -> void:
	fisico_container.visible = toggled_on

func _on_social_button_toggled(toggled_on: bool) -> void:
	social_container.visible = toggled_on

func _on_metal_button_toggled(toggled_on: bool) -> void:
	mental_container.visible = toggled_on

func _on_espiritual_button_toggled(toggled_on: bool) -> void:
	espiritual_container.visible = toggled_on
