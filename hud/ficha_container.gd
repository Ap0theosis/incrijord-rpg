extends PanelContainer

var HUD = null
var token = null

@onready var edit_close_container: VBoxContainer = $"../EditCloseContainer"
@onready var ficha_menu_container: VBoxContainer = $"../FichaMenuContainer"
@onready var tokens_node: Node2D = $"../../Tokens"
@onready var polaridade_animation: AnimatedSprite2D = $Margin/Habilidades/VBoxContainer/AnimatedSprite2D
@onready var ficha_habilidades_carga_spinbox: SpinBox = $Margin/Habilidades/VBoxContainer/SoulSkill/VBoxContainer/HBoxContainer/SpinBox
@onready var ficha_habilidades_sanidade: Label = $Margin/Habilidades/VBoxContainer/HBoxContainer/Label2
@onready var ficha_habilidades_postura: Label = $Margin/Habilidades/VBoxContainer/HBoxContainer2/Label2

@onready var ficha_habilidades_custo: RichTextLabel = $Margin/Habilidades/VBoxContainer/SoulSkill/VBoxContainer/Panel2/VBoxContainer/Custo
@onready var ficha_habilidades_valor: RichTextLabel = $Margin/Habilidades/VBoxContainer/SoulSkill/VBoxContainer/Panel2/VBoxContainer/Valor
@onready var ficha_habilidades_valormaximo: RichTextLabel = $Margin/Habilidades/VBoxContainer/SoulSkill/VBoxContainer/Panel2/VBoxContainer/ValorMaximo
@onready var ficha_habilidades_acerto: Label = $Margin/Habilidades/VBoxContainer/SoulSkill/VBoxContainer/HBoxContainer/VBoxContainer/Label2
@onready var ficha_habilidades_acertomedo: Label = $Margin/Habilidades/VBoxContainer/SoulSkill/VBoxContainer/HBoxContainer/VBoxContainer/Label3

@onready var ficha_habilidades_tituloskill: Label = $Margin/Habilidades/VBoxContainer/SoulSkill/VBoxContainer/Panel/RankSkill
@onready var ficha_geral: Control = $Margin/Geral
@onready var geral_button: Button = $"../FichaMenuContainer/GeralButton"


const FICHA_COMPLETA = preload("res://hud/ficha_detalhes.tscn")

@onready var EDIT_LINES =[
	$Margin/Geral/VBoxContainer/AlmaContainer/AlmaEdit,
	$Margin/Geral/VBoxContainer/FobiaContainer/FobiaEdit,
	$Margin/Geral/VBoxContainer/CreditsContainer/CreditsValueEdit,
	$Margin/Geral/VBoxContainer/CreditsContainer/CreditsLimitEdit,
	$Margin/Geral/VBoxContainer/MorteContainer/MorteEdit,
	$Margin/Geral/VBoxContainer/MorteContainer/MorteMaxEdit,
	$Margin/Geral/VBoxContainer/MedoContainer/MedoEdit,
	$Margin/Geral/VBoxContainer/MedoContainer/MedoMaxEdit,
	$Margin/Geral/VBoxContainer/VidaContainer/VidaEdit,
	$Margin/Geral/VBoxContainer/VidaContainer/VidaMaxEdit,
	$Margin/Geral/VBoxContainer/TempContainer/VTempEdit,
	$Margin/Geral/VBoxContainer/TempContainer/VTempMaxEdit,
	$Margin/Geral/VBoxContainer/SanContainer/SanEdit,
	$Margin/Geral/VBoxContainer/SanContainer/SanMaxEdit,
	$Margin/Geral/VBoxContainer/PosContainer/PosEdit,
	$Margin/Geral/VBoxContainer/PosContainer/PosMaxEdit,
	$Margin/Geral/VBoxContainer/ResContainer/ResFEdit, 
	$Margin/Geral/VBoxContainer/ResContainer/ResMEdit,
	$"../EditCloseContainer/ColorPickerButton",
	$"../EditCloseContainer/UploadButton",
	$Margin/Atributos/VBoxContainer/CorpoContainer/CorpoEdit,
	$Margin/Atributos/VBoxContainer/DestrezaContainer/DestrezaEdit,
	$Margin/Atributos/VBoxContainer/MenteContainer/MenteEdit,
	$Margin/Atributos/VBoxContainer/EspiritoContainer/EspiritoEdit,
	$Margin/Atributos/VBoxContainer/CarismaContainer/CarismaEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/PurificacaoContainer/PurificacaoEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/IlusaoContainer/IlusaoEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/SeloContainer/SeloEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/BencaoMaldicaoContainer/BencaoMaldicaoEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/ConjuracaoContainer/ConjuracaoEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/ClarividenciaContainer/ClarividenciaEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/SobrecargaContainer/SobrecargaEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/FurtividadeContainer/FurtividadeEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/PrestidigitacaoContainer/PrestidigitacaoEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/InstintoContainer/InstintoEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/AcrobaciaContainer/AcrobaciaEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/AtletismoContainer/AtletismoEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/AdrenalinaContainer/AdrenalinaEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/RigidezContainer/RigidezEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/IntimidacaoContainer/IntimidacaoEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/ArtesContainer/ArtesEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/PersuasaoContainer/PersuasaoEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/PerspicaciaContainer/PerspicaciaEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/LidarCriaturasContainer/LidarCriaturasEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/EncorajarContainer/EncorajarEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/EncantarContainer/EncantarEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/AparelhagemContainer/AparelhagemEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/MedicinaContainer/MedicinaEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/GastronomiaContainer/GastronomiaEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/InvestigacaoContainer/InvestigacaoEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/CriaçãoContainer/CriaçãoEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/CoragemContainer/CoragemEdit,
	$Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/SobrevivenciaContainer/SobrevivenciaEdit
]

func _ready() -> void:
	HUD = get_parent()

func _on_selected_token(id) -> void:
	$"../..".selected = token
	
	ficha_menu_container.show()
	ficha_geral.show()
	edit_close_container.show()
	
	geral_button.button_pressed = true
	
	editing = false
	for edit in EDIT_LINES:
		edit.hide()
	
	for child in tokens_node.get_children():
		if child.name != id:
			child.selected = false
			child.update_hud()
		else:
			token = child
			
	definir_ficha()
	show()
	$Margin/Habilidades/VBoxContainer/SoulSkill/VBoxContainer/Panel2/VBoxContainer/Insuficiente.hide()

@onready var ficha_name: Label = $Margin/Geral/VBoxContainer/Name
@onready var ficha_icon: TextureRect = $Margin/Geral/VBoxContainer/IconBG/Icon
@onready var ficha_icon_bg: TextureRect = $Margin/Geral/VBoxContainer/IconBG
@onready var ficha_race: Label = $Margin/Geral/VBoxContainer/Race
@onready var ficha_foco: Label = $Margin/Geral/VBoxContainer/Focus
@onready var ficha_aspiration: Label = $Margin/Geral/VBoxContainer/Aspiration
@onready var ficha_aspecto: Label = $Margin/Geral/VBoxContainer/AspectContainer/Label2
@onready var ficha_alma: Label = $Margin/Geral/VBoxContainer/AlmaContainer/Label2
@onready var ficha_fobia: Label = $Margin/Geral/VBoxContainer/FobiaContainer/Label2
@onready var ficha_credits: Label = $Margin/Geral/VBoxContainer/CreditsContainer/CreditsValue
@onready var ficha_limit: Label = $Margin/Geral/VBoxContainer/CreditsContainer/CreditsLimit
@onready var ficha_morte: Label = $Margin/Geral/VBoxContainer/MorteContainer/Value
@onready var ficha_max_morte: Label = $Margin/Geral/VBoxContainer/MorteContainer/Max
@onready var ficha_medo: Label = $Margin/Geral/VBoxContainer/MedoContainer/Value
@onready var ficha_max_medo: Label = $Margin/Geral/VBoxContainer/MedoContainer/Max
@onready var ficha_vida: Label = $Margin/Geral/VBoxContainer/VidaContainer/Value
@onready var ficha_max_vida: Label = $Margin/Geral/VBoxContainer/VidaContainer/Max
@onready var ficha_vidatemp: Label = $Margin/Geral/VBoxContainer/TempContainer/Value
@onready var ficha_max_vidatemp: Label = $Margin/Geral/VBoxContainer/TempContainer/Max
@onready var ficha_sanidade: Label = $Margin/Geral/VBoxContainer/SanContainer/Value
@onready var ficha_max_sanidade: Label = $Margin/Geral/VBoxContainer/SanContainer/Max
@onready var ficha_postura: Label = $Margin/Geral/VBoxContainer/PosContainer/Value
@onready var ficha_max_postura: Label = $Margin/Geral/VBoxContainer/PosContainer/Max
@onready var ficha_resist_fisica: Label = $Margin/Geral/VBoxContainer/ResContainer/Value
@onready var ficha_resist_magica: Label = $Margin/Geral/VBoxContainer/ResContainer/Value2

@onready var ficha_atributos_name: Label = $Margin/Atributos/VBoxContainer/Name
@onready var ficha_atributos_rank: Label = $Margin/Atributos/VBoxContainer/Rank
@onready var ficha_atributos_icon: TextureRect = $Margin/Atributos/VBoxContainer/Icon
@onready var ficha_atributos_corpo: Label = $Margin/Atributos/VBoxContainer/CorpoContainer/CorpoValue
@onready var ficha_atributos_destreza: Label = $Margin/Atributos/VBoxContainer/DestrezaContainer/DestrezaValue
@onready var ficha_atributos_mente: Label = $Margin/Atributos/VBoxContainer/MenteContainer/MenteValue
@onready var ficha_atributos_espirito: Label = $Margin/Atributos/VBoxContainer/EspiritoContainer/EspiritoValue
@onready var ficha_atributos_carisma: Label = $Margin/Atributos/VBoxContainer/CarismaContainer/CarismaValue
@onready var ficha_atributos_furtividade: Label = $Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/FurtividadeContainer/FurtividadeValue
@onready var ficha_atributos_prestidigitacao: Label = $Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/PrestidigitacaoContainer/PrestidigitacaoValue
@onready var ficha_atributos_instinto: Label = $Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/InstintoContainer/InstintoValue
@onready var ficha_atributos_acrobacia: Label = $Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/AcrobaciaContainer/AcrobaciaValue
@onready var ficha_atributos_atletismo: Label = $Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/AtletismoContainer/AtletismoValue
@onready var ficha_atributos_adrenalina: Label = $Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/AdrenalinaContainer/AdrenalinaValue
@onready var ficha_atributos_rigidez: Label = $Margin/Atributos/VBoxContainer/PanelContainer/FisicoContainer/RigidezContainer/RigidezValue
@onready var ficha_atributos_intimidacao: Label = $Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/IntimidacaoContainer/IntimidacaoValue
@onready var ficha_atributos_artes: Label = $Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/ArtesContainer/ArtesValue
@onready var ficha_atributos_persuasao: Label = $Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/PersuasaoContainer/PersuasaoValue
@onready var ficha_atributos_perspicacia: Label = $Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/PerspicaciaContainer/PerspicaciaValue
@onready var ficha_atributos_lidar_criaturas: Label = $Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/LidarCriaturasContainer/LidarCriaturasValue
@onready var ficha_atributos_encorajar: Label = $Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/EncorajarContainer/EncorajarValue
@onready var ficha_atributos_encantar: Label = $Margin/Atributos/VBoxContainer/PanelContainer/SocialContainer/EncantarContainer/EncantarValue
@onready var ficha_atributos_aparelhagem: Label = $Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/AparelhagemContainer/AparelhagemValue
@onready var ficha_atributos_medicina: Label = $Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/MedicinaContainer/MedicinaValue
@onready var ficha_atributos_gastronomia: Label = $Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/GastronomiaContainer/GastronomiaValue
@onready var ficha_atributos_investigacao: Label = $Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/InvestigacaoContainer/InvestigacaoValue
@onready var ficha_atributos_criacao: Label = $Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/CriaçãoContainer/CriaçãoValue
@onready var ficha_atributos_coragem: Label = $Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/CoragemContainer/CoragemValue
@onready var ficha_atributos_sobrevivencia: Label = $Margin/Atributos/VBoxContainer/PanelContainer/MentalContainer/SobrevivenciaContainer/SobrevivenciaValue
@onready var ficha_atributos_purificacao: Label = $Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/PurificacaoContainer/PurificacaoValue
@onready var ficha_atributos_ilusao: Label = $Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/IlusaoContainer/IlusaoValue
@onready var ficha_atributos_selo: Label = $Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/SeloContainer/SeloValue
@onready var ficha_atributos_bencao_maldicao: Label = $Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/BencaoMaldicaoContainer/BencaoMaldicaoValue
@onready var ficha_atributos_conjuracao: Label = $Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/ConjuracaoContainer/ConjuracaoValue
@onready var ficha_atributos_clarividencia: Label = $Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/ClarividenciaContainer/ClarividenciaValue
@onready var ficha_atributos_sobrecarga: Label = $Margin/Atributos/VBoxContainer/PanelContainer/EspiritualContainer/SobrecargaContainer/SobrecargaValue
@onready var ficha_rank_icon: TextureRect = $Margin/Geral/VBoxContainer/IconBG/RankIcon
@onready var ficha_atributos_bonus_rank: Label = $Margin/Atributos/VBoxContainer/BonusRankContainer/BonusRankValue

@onready var color_picker_button: ColorPickerButton = $"../EditCloseContainer/ColorPickerButton"

func _on_detalhes_button_pressed() -> void:
	var new_ficha = FICHA_COMPLETA.instantiate()
	new_ficha.token = token
	HUD.add_child(new_ficha)
	edit_close_container.hide()
	ficha_menu_container.hide()
	hide()
	
@onready var ficha_habilidades_name: Label = $Margin/Habilidades/VBoxContainer/Name

var cargas = 1
var custo = 0
var custo_final = 0
var valor = 0
var valormaximo = 0
var invertido = false
var usar_postura = false

func definir_ficha() -> void:
	if not (token and token.stats):
		return
	
	var data: TokenData = token.stats
	var rank_info = Alma.RANK_C
	
		# --- VISUAIS E BÁSICOS ---
	ficha_rank_icon.texture = TokensManager.RANK_ICONS.get(data.rank)
	color_picker_button.color = token.token_texture.self_modulate
	ficha_atributos_icon.self_modulate = data.token_cor
	ficha_icon.texture = data.icone
	
	# --- TEXTOS INFORMATIVOS ---
	ficha_name.text = data.nome
	ficha_atributos_name.text = data.nome
	ficha_atributos_rank.text = "Rank " + data.rank
	ficha_race.text = data.raca
	ficha_foco.text = data.foco
	ficha_aspiration.text = data.aspiracao
	ficha_aspecto.text = data.aspecto
	ficha_alma.text = data.alma
	ficha_fobia.text = data.fobia
	
	# --- STATUS E ATRIBUTOS NUMÉRICOS ---
	ficha_credits.text = str(data.creditos)
	ficha_limit.text = str(data.limite)
	ficha_morte.text = str(data.morte)
	ficha_max_morte.text = str(data.max_morte)
	ficha_medo.text = str(data.medo)
	ficha_max_medo.text = str(data.max_medo)
	ficha_vida.text = str(data.vida)
	ficha_max_vida.text = str(data.max_vida)
	ficha_vidatemp.text = str(data.vidatemp)
	ficha_max_vidatemp.text = str(data.max_vidatemp)
	ficha_sanidade.text = str(data.sanidade)
	ficha_max_sanidade.text = str(data.max_sanidade)
	ficha_postura.text = str(data.postura)
	ficha_max_postura.text = str(data.max_postura)
	ficha_resist_fisica.text = str(data.resist_fisica)
	ficha_resist_magica.text = str(data.resist_magica)
	
	
	ficha_atributos_corpo.text = str(data.corpo)
	ficha_atributos_destreza.text = str(data.destreza)
	ficha_atributos_mente.text = str(data.mente)
	ficha_atributos_espirito.text = str(data.espirito)
	ficha_atributos_carisma.text = str(data.carisma)
	
	# --- PERÍCIAS ---
	var p = data.pericias
	ficha_atributos_furtividade.text = str(p["fisico"]["furtividade"]["value"])
	ficha_atributos_prestidigitacao.text = str(p["fisico"]["prestidigitacao"]["value"])
	ficha_atributos_instinto.text = str(p["fisico"]["instinto"]["value"])
	ficha_atributos_acrobacia.text = str(p["fisico"]["acrobacia"]["value"])
	ficha_atributos_atletismo.text = str(p["fisico"]["atletismo"]["value"])
	ficha_atributos_adrenalina.text = str(p["fisico"]["adrenalina"]["value"])
	ficha_atributos_rigidez.text = str(p["fisico"]["rigidez"]["value"])
	
	ficha_atributos_intimidacao.text = str(p["social"]["intimidacao"]["value"])
	ficha_atributos_artes.text = str(p["social"]["artes"]["value"])
	ficha_atributos_persuasao.text = str(p["social"]["persuasao"]["value"])
	ficha_atributos_perspicacia.text = str(p["social"]["perspicacia"]["value"])
	ficha_atributos_lidar_criaturas.text = str(p["social"]["lidar_criaturas"]["value"])
	ficha_atributos_encorajar.text = str(p["social"]["encorajar"]["value"])
	ficha_atributos_encantar.text = str(p["social"]["encantar"]["value"])
	
	ficha_atributos_aparelhagem.text = str(p["mental"]["aparelhagem"]["value"])
	ficha_atributos_medicina.text = str(p["mental"]["medicina"]["value"])
	ficha_atributos_gastronomia.text = str(p["mental"]["gastronomia"]["value"])
	ficha_atributos_investigacao.text = str(p["mental"]["investigacao"]["value"])
	ficha_atributos_criacao.text = str(p["mental"]["criacao"]["value"])
	ficha_atributos_coragem.text = str(p["mental"]["coragem"]["value"])
	ficha_atributos_sobrevivencia.text = str(p["mental"]["sobrevivencia"]["value"])
	
	ficha_atributos_purificacao.text = str(p["espiritual"]["purificacao"]["value"])
	ficha_atributos_ilusao.text = str(p["espiritual"]["ilusao"]["value"])
	ficha_atributos_selo.text = str(p["espiritual"]["selo"]["value"])
	ficha_atributos_bencao_maldicao.text = str(p["espiritual"]["bencao_maldicao"]["value"])
	ficha_atributos_conjuracao.text = str(p["espiritual"]["conjuracao"]["value"])
	ficha_atributos_clarividencia.text = str(p["espiritual"]["clarividencia"]["value"])
	ficha_atributos_sobrecarga.text = str(p["espiritual"]["sobrecarga"]["value"])
	
	ficha_atributos_bonus_rank.text = str(data.bonus_rank)
	
	match data.rank:
		"C", "C+":
			rank_info = Alma.RANK_C
			ficha_habilidades_tituloskill.text = "Habilidade Comum"
			ficha_habilidades_tituloskill.modulate = Color("#b45f06")
		"B", "B+":
			rank_info = Alma.RANK_B
			ficha_habilidades_tituloskill.text = "Habilidade Base"
			ficha_habilidades_tituloskill.modulate = Color("674ea7")
	
	var aspecto_atual = token.stats["aspecto"]
	if invertido:
		match aspecto_atual:
			"Polus":
				aspecto_atual = "Minus"
			"Minus":
				aspecto_atual = "Polus"
	
	var cor = rank_info[aspecto_atual]["cor"]
	
	custo_final = rank_info[aspecto_atual]["custo_final"]
	custo = cargas + custo_final
	valor = rank_info[aspecto_atual]["valor_cargas"]
	valormaximo = cargas * valor
	polaridade_animation.play(aspecto_atual)
	
	ficha_habilidades_name.text = data.nome
	ficha_habilidades_sanidade.text = str(data.sanidade)
	ficha_habilidades_postura.text = str(data.postura)
	ficha_habilidades_carga_spinbox.max_value = rank_info[aspecto_atual]["limite_cargas"]
	
	if usar_postura:
		ficha_habilidades_custo.text = "Você perderá [color=4a86e8]%s de postura" % custo
	else:
		ficha_habilidades_custo.text = "Você perderá [color=4a86e8]%s de sanidade" % custo
	ficha_habilidades_valor.text = "Valor por Carga: [color=%s]%s" % [cor, valor]
	ficha_habilidades_valormaximo.text = "[color=%s]Valor máximo: %s" % [cor, valormaximo]
	
	if aspecto_atual == "Minus":
		if data.rank in ["C", "C+"]:
			ficha_habilidades_acertomedo.text = "+%s (Medo*2)" % (token.stats["medo"]*2)
		elif data.rank in ["B", "B+"]:
			ficha_habilidades_acertomedo.text = "+%s (Medo*4)" % (token.stats["medo"]*4)
		ficha_habilidades_acertomedo.show()
	else:
		ficha_habilidades_acertomedo.hide()
	
	ficha_habilidades_acerto.text = "D20 + %s (%s)" % [data.get_maior_atributo().values()[0], data.get_maior_atributo().keys()[0]]

func _on_cargas_value_changed(value: float) -> void:
	cargas = int(value)
	definir_ficha()

func _on_check_button_toggled(toggled_on: bool) -> void:
	invertido = toggled_on
	definir_ficha()

func _on_rolar_cargas_pressed() -> void:
	var aspecto_atual = token.stats["aspecto"]
	var moeda = "sanidade"
	
	if usar_postura:
		moeda = "postura"
	
	if invertido:
		match aspecto_atual:
			"Polus":
				aspecto_atual = "Minus"
			"Minus":
				aspecto_atual = "Polus"
	
	var valor_atual = token.stats.get(moeda)
	
	if valor_atual >= custo:
		var novo_valor = valor_atual - custo
		sincronizar_atributo.rpc(moeda, novo_valor)
		
		token.spawn_charges.rpc(cargas, valor, 1, aspecto_atual)
		token.update_hud.rpc()
		
		$Margin/Habilidades/VBoxContainer/SoulSkill/VBoxContainer/Panel2/VBoxContainer/Insuficiente.hide()
	else:
		$Margin/Habilidades/VBoxContainer/SoulSkill/VBoxContainer/Panel2/VBoxContainer/Insuficiente.show()


func _on_postura_toggled(toggled_on: bool) -> void:
	usar_postura = toggled_on
	definir_ficha()

func _on_color_changed(color: Color) -> void:
	if token and token.stats:
		sincronizar_atributo.rpc("token_cor", color)

var editing = false

func _on_color_popup_closed() -> void:
	editing = false
	for edit_line in EDIT_LINES:
		edit_line.hide()
		if edit_line is LineEdit:
			edit_line.clear()

func _on_edit_button_pressed() -> void:
	if not editing:
		editing = true
		for edit in EDIT_LINES:
			edit.show()
	else:
		editing = false
		for edit in EDIT_LINES:
			edit.hide()

func _on_geral_edit_text_submitted(new_text: String, type) -> void:
	if not (token and token.stats):
		return
	
	const STRING_INPUT = ["alma", "fobia"]
	
	var valor_final
	if STRING_INPUT.has(type):
		valor_final = new_text
	else:
		valor_final = int(new_text)
	
	sincronizar_atributo.rpc(type, valor_final)
	token.update_hud.rpc()
	
	editing = false
	for edit_line in EDIT_LINES:
		edit_line.hide()
		if edit_line is LineEdit:
			edit_line.clear()

func _on_pericia_edit_text_submitted(new_text: String, type) -> void:
	if not (token and token.stats):
		return
	
	const FISICO = ["furtividade", "prestidigitacao", "instinto", "acrobacia", "atletismo", "adrenalina", "rigidez"]
	const SOCIAL = ["intimidacao", "artes", "persuasao", "perspicacia", "lidar_criaturas", "encorajar", "encantar"]
	const MENTAL = ["aparelhagem", "medicina", "gastronomia", "investigacao", "criacao", "coragem", "sobrevivencia"]
	const ESPIRITUAL = ["purificacao", "ilusao", "selo", "bencao_maldicao", "conjuracao", "clarividencia", "sobrecarga"]
	
	var new_valor = int(new_text)
	
	if FISICO.has(type):
		sincronizar_pericia.rpc("fisico", type, new_valor)
	elif SOCIAL.has(type):
		sincronizar_pericia.rpc("social", type, new_valor)
	elif MENTAL.has(type):
		sincronizar_pericia.rpc("mental", type, new_valor)
	elif ESPIRITUAL.has(type):
		sincronizar_pericia.rpc("espiritual", type, new_valor)
	
	editing = false
	for edit_line in EDIT_LINES:
		edit_line.hide()
		if edit_line is LineEdit:
			edit_line.clear()


@rpc("any_peer", "call_local", "reliable")
func sincronizar_atributo(propriedade: String, new_valor) -> void:
	if not (token and token.stats):
		return
	
	token.stats.set(propriedade, new_valor)
	
	if propriedade == "token_cor":
		token.apply_hex_color()
	
	definir_ficha()
	

@rpc("any_peer", "call_local", "reliable")
func sincronizar_pericia(categoria: String, nome_pericia: String, novo_valor: int) -> void:
	if not (token and token.stats):
		return
		
	token.stats.pericias[categoria][nome_pericia]["value"] = novo_valor
	definir_ficha()
