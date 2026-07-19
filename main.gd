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
@onready var color_picker_button: ColorPickerButton = $HUD/EditCloseContainer/ColorPickerButton

@onready var ficha_menu_container: VBoxContainer = $HUD/FichaMenuContainer


enum REGIONS {Gama, Tiamatia, Svenia, Magilith, Rubiavéu, Yamagon, Breu, Levorith, MundoHumano, Nartá, X}
var zoom = 100
var selected = null
var time = 0
var day_night = false
var editing = false

func _ready() -> void:
	if OS.has_feature("web_android"):
		virtual_joystick.show()
	if not multiplayer.is_server():
		region_option_button.hide()
		choose_time_button.hide()
		time_options.hide()
		mestre_button.hide()

func _on_selected_token(id) -> void:
	ficha_menu_container.show()
	geral_button.button_pressed = true
	ficha_geral.show()
	
	
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
	ficha_menu_container.hide()
	$HUD/EditCloseContainer.hide()
	ficha_container.hide()
	
	for child in $Tokens.get_children():
		child.selected = false
		child.update_hud()
	for child in $TargetMarkers.get_children():
		child.queue_free()
	selected = null


@onready var ficha_name: Label = $HUD/FichaContainer/Margin/Geral/VBoxContainer/Name
@onready var ficha_icon: TextureRect = $HUD/FichaContainer/Margin/Geral/VBoxContainer/IconBG/Icon
@onready var ficha_icon_bg: TextureRect = $HUD/FichaContainer/Margin/Geral/VBoxContainer/IconBG
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

@onready var ficha_atributos_name: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/Name
@onready var ficha_atributos_rank: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/Rank
@onready var ficha_atributos_icon: TextureRect = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/Icon
@onready var ficha_atributos_corpo: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/CorpoContainer/CorpoValue
@onready var ficha_atributos_destreza: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/DestrezaContainer/DestrezaValue
@onready var ficha_atributos_mente: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/MenteContainer/MenteValue
@onready var ficha_atributos_espirito: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/EspiritoContainer/EspiritoValue
@onready var ficha_atributos_carisma: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/CarismaContainer/CarismaValue
@onready var ficha_atributos_furtividade: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/FurtividadeContainer/FurtividadeValue
@onready var ficha_atributos_prestidigitacao: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/PrestidigitacaoContainer/PrestidigitacaoValue
@onready var ficha_atributos_instinto: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/InstintoContainer/InstintoValue
@onready var ficha_atributos_acrobacia: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/AcrobaciaContainer/AcrobaciaValue
@onready var ficha_atributos_atletismo: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/AtletismoContainer/AtletismoValue
@onready var ficha_atributos_adrenalina: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/AdrenalinaContainer/AdrenalinaValue
@onready var ficha_atributos_rigidez: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/RigidezContainer/RigidezValue
@onready var ficha_atributos_intimidacao: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/IntimidacaoContainer/IntimidacaoValue
@onready var ficha_atributos_artes: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/ArtesContainer/ArtesValue
@onready var ficha_atributos_persuasao: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/PersuasaoContainer/PersuasaoValue
@onready var ficha_atributos_perspicacia: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/PerspicaciaContainer/PerspicaciaValue
@onready var ficha_atributos_lidar_criaturas: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/LidarCriaturasContainer/LidarCriaturasValue
@onready var ficha_atributos_encorajar: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/EncorajarContainer/EncorajarValue
@onready var ficha_atributos_encantar: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/EncantarContainer/EncantarValue
@onready var ficha_atributos_aparelhagem: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/AparelhagemContainer/AparelhagemValue
@onready var ficha_atributos_medicina: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/MedicinaContainer/MedicinaValue
@onready var ficha_atributos_gastronomia: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/GastronomiaContainer/GastronomiaValue
@onready var ficha_atributos_investigacao: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/InvestigacaoContainer/InvestigacaoValue
@onready var ficha_atributos_criacao: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/CriaçãoContainer/CriaçãoValue
@onready var ficha_atributos_coragem: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/CoragemContainer/CoragemValue
@onready var ficha_atributos_sobrevivencia: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/SobrevivenciaContainer/SobrevivenciaValue
@onready var ficha_atributos_purificacao: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/PurificacaoContainer/PurificacaoValue
@onready var ficha_atributos_ilusao: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/IlusaoContainer/IlusaoValue
@onready var ficha_atributos_selo: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/SeloContainer/SeloValue
@onready var ficha_atributos_bencao_maldicao: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/BencaoMaldicaoContainer/BencaoMaldicaoValue
@onready var ficha_atributos_conjuracao: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/ConjuracaoContainer/ConjuracaoValue
@onready var ficha_atributos_clarividencia: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/ClarividenciaContainer/ClarividenciaValue
@onready var ficha_atributos_sobrecarga: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/SobrecargaContainer/SobrecargaValue
@onready var ficha_rank_icon: TextureRect = $HUD/FichaContainer/Margin/Geral/VBoxContainer/IconBG/RankIcon
@onready var ficha_atributos_bonus_rank: Label = $HUD/FichaContainer/Margin/Atributos/VBoxContainer/BonusRankContainer/BonusRankValue

func definir_ficha() -> void:
	if selected:
		if selected.stats:
			ficha_rank_icon.texture = TokensData.RANK_ICONS[selected.stats["rank"]]
			
			color_picker_button.color = selected.token_texture.self_modulate
			ficha_atributos_icon.self_modulate = selected.stats["token_color"]
			ficha_name.text = selected.stats["name"]
			ficha_atributos_name.text = selected.stats["name"]
			ficha_atributos_rank.text = "Rank " + selected.stats["rank"]
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
			
			
			ficha_atributos_corpo.text = str(selected.stats["corpo"])
			ficha_atributos_destreza.text = str(selected.stats["destreza"])
			ficha_atributos_mente.text = str(selected.stats["mente"])
			ficha_atributos_espirito.text = str(selected.stats["espirito"])
			ficha_atributos_carisma.text = str(selected.stats["carisma"])
			
			ficha_atributos_furtividade.text = str(selected.stats["pericias"]["fisico"]["furtividade"]["value"])
			ficha_atributos_prestidigitacao.text = str(selected.stats["pericias"]["fisico"]["prestidigitacao"]["value"])
			ficha_atributos_instinto.text = str(selected.stats["pericias"]["fisico"]["instinto"]["value"])
			ficha_atributos_acrobacia.text = str(selected.stats["pericias"]["fisico"]["acrobacia"]["value"])
			ficha_atributos_atletismo.text = str(selected.stats["pericias"]["fisico"]["atletismo"]["value"])
			ficha_atributos_adrenalina.text = str(selected.stats["pericias"]["fisico"]["adrenalina"]["value"])
			ficha_atributos_rigidez.text = str(selected.stats["pericias"]["fisico"]["rigidez"]["value"])
			
			ficha_atributos_intimidacao.text = str(selected.stats["pericias"]["social"]["intimidacao"]["value"])
			ficha_atributos_artes.text = str(selected.stats["pericias"]["social"]["artes"]["value"])
			ficha_atributos_persuasao.text = str(selected.stats["pericias"]["social"]["persuasao"]["value"])
			ficha_atributos_perspicacia.text = str(selected.stats["pericias"]["social"]["perspicacia"]["value"])
			ficha_atributos_lidar_criaturas.text = str(selected.stats["pericias"]["social"]["lidar_criaturas"]["value"])
			ficha_atributos_encorajar.text = str(selected.stats["pericias"]["social"]["encorajar"]["value"])
			ficha_atributos_encantar.text = str(selected.stats["pericias"]["social"]["encantar"]["value"])
			
			ficha_atributos_aparelhagem.text = str(selected.stats["pericias"]["mental"]["aparelhagem"]["value"])
			ficha_atributos_medicina.text = str(selected.stats["pericias"]["mental"]["medicina"]["value"])
			ficha_atributos_gastronomia.text = str(selected.stats["pericias"]["mental"]["gastronomia"]["value"])
			ficha_atributos_investigacao.text = str(selected.stats["pericias"]["mental"]["investigacao"]["value"])
			ficha_atributos_criacao.text = str(selected.stats["pericias"]["mental"]["criacao"]["value"])
			ficha_atributos_coragem.text = str(selected.stats["pericias"]["mental"]["coragem"]["value"])
			ficha_atributos_sobrevivencia.text = str(selected.stats["pericias"]["mental"]["sobrevivencia"]["value"])
			
			ficha_atributos_purificacao.text = str(selected.stats["pericias"]["espiritual"]["purificacao"]["value"])
			ficha_atributos_ilusao.text = str(selected.stats["pericias"]["espiritual"]["ilusao"]["value"])
			ficha_atributos_selo.text = str(selected.stats["pericias"]["espiritual"]["selo"]["value"])
			ficha_atributos_bencao_maldicao.text = str(selected.stats["pericias"]["espiritual"]["bencao_maldicao"]["value"])
			ficha_atributos_conjuracao.text = str(selected.stats["pericias"]["espiritual"]["conjuracao"]["value"])
			ficha_atributos_clarividencia.text = str(selected.stats["pericias"]["espiritual"]["clarividencia"]["value"])
			ficha_atributos_sobrecarga.text = str(selected.stats["pericias"]["espiritual"]["sobrecarga"]["value"])
			
			ficha_atributos_bonus_rank.text = str(selected.stats["bonus_rank"])
			



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
	var token_id = selected.stats["id"]
	TokensData.players[token_id]["token_color"] = color
	selected.apply_hex_color()


func _on_geral_edit_text_submitted(new_text: String, type) -> void:
	const STRING_INPUT = ["alma", "fobia"]
	var token_id = selected.stats["id"]
	if STRING_INPUT.has(type):
		TokensData.players[token_id][type] = new_text
	else:
		TokensData.players[token_id][type] = int(new_text)
	selected.update_hud.rpc()
	definir_ficha()
	editing = false
	for edit_line in EDIT_LINES:
		edit_line.hide()
		if edit_line is LineEdit:
			edit_line.clear()

func _on_pericia_edit_text_submitted(new_text: String, type) -> void:
	const FISICO = ["furtividade", "prestidigitacao", "instinto", "acrobacia", "atletismo", "adrenalina", "rigidez"]
	const SOCIAL = ["intimidacao", "artes", "persuasao", "perspicacia", "lidar_criaturas", "encorajar", "encantar"]
	const MENTAL = ["aparelhagem", "medicina", "gastronomia", "investigacao", "criacao", "coragem", "sobrevivencia"]
	const ESPIRITUAL = ["purificacao", "ilusao", "selo", "bencao_maldicao", "conjuracao", "clarividencia", "sobrecarga"]
	var token_id = selected.stats["id"]
	if FISICO.has(type):
		TokensData.players[token_id]["pericias"]["fisico"][type]["value"] = int(new_text)
	elif SOCIAL.has(type):
		TokensData.players[token_id]["pericias"]["social"][type]["value"] = int(new_text)
	elif MENTAL.has(type):
		TokensData.players[token_id]["pericias"]["mental"][type]["value"] = int(new_text)
	elif ESPIRITUAL.has(type):
		TokensData.players[token_id]["pericias"]["espiritual"][type]["value"] = int(new_text)
	definir_ficha()
	editing = false
	for edit_line in EDIT_LINES:
		edit_line.hide()
		if edit_line is LineEdit:
			edit_line.clear()

@onready var geral_button: Button = $HUD/FichaMenuContainer/GeralButton
@onready var atributos_button: Button = $HUD/FichaMenuContainer/AtributosButton

@onready var ficha_geral: Control = $HUD/FichaContainer/Margin/Geral
@onready var ficha_atributos: Control = $HUD/FichaContainer/Margin/Atributos

func _on_atributos_button_toggled(toggled_on: bool) -> void:
	ficha_atributos.visible = toggled_on

func _on_geral_button_toggled(toggled_on: bool) -> void:
	ficha_geral.visible = toggled_on
	
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
