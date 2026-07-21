extends PanelContainer

var HUD = null
var token = null

@onready var edit_close_container: VBoxContainer = $"../EditCloseContainer"
@onready var ficha_menu_container: VBoxContainer = $"../FichaMenuContainer"
@onready var tokens_node: Node2D = $"../../Tokens"
@onready var polaridade_animation: AnimatedSprite2D = $Margin/Habilidades/VBoxContainer/AnimatedSprite2D
@onready var ficha_habilidades_carga_spinbox: SpinBox = $Margin/Habilidades/VBoxContainer/RankC/VBoxContainer/HBoxContainer/SpinBox
@onready var ficha_habilidades_sanidade: Label = $Margin/Habilidades/VBoxContainer/HBoxContainer/Label2
@onready var ficha_habilidades_custo: RichTextLabel = $Margin/Habilidades/VBoxContainer/RankC/VBoxContainer/Panel2/VBoxContainer/Custo
@onready var ficha_habilidades_valor: RichTextLabel = $Margin/Habilidades/VBoxContainer/RankC/VBoxContainer/Panel2/VBoxContainer/Valor
@onready var ficha_habilidades_valormaximo: RichTextLabel = $Margin/Habilidades/VBoxContainer/RankC/VBoxContainer/Panel2/VBoxContainer/ValorMaximo
@onready var ficha_habilidades_acerto: Label = $Margin/Habilidades/VBoxContainer/RankC/VBoxContainer/HBoxContainer/VBoxContainer/Label2
@onready var ficha_habilidades_acertomedo: Label = $Margin/Habilidades/VBoxContainer/RankC/VBoxContainer/HBoxContainer/VBoxContainer/Label3

const FICHA_COMPLETA = preload("res://hud/ficha_detalhes.tscn")

func _ready() -> void:
	HUD = get_parent()

func _on_selected_token(id) -> void:
	for child in tokens_node.get_children():
		if child.name != id:
			child.selected = false
			child.update_hud()
		else:
			token = child
			
	definir_ficha()


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

func definir_ficha() -> void:
	if not (token and token.stats):
		return
	
	var aspecto_atual = token.stats["aspecto"]
	
	if invertido:
		match aspecto_atual:
			"Polus":
				aspecto_atual = "Minus"
			"Minus":
				aspecto_atual = "Polus"
	
	var cor = Alma.RANK_C[aspecto_atual]["cor"]
	
	custo_final = Alma.RANK_C[aspecto_atual]["custo_final"]
	custo = cargas + custo_final
	valor = Alma.RANK_C[aspecto_atual]["valor_cargas"]
	valormaximo = cargas * valor
	polaridade_animation.play(aspecto_atual)
	
	ficha_habilidades_name.text = token.stats["name"]
	ficha_habilidades_sanidade.text = str(token.stats["sanidade"])
	ficha_habilidades_carga_spinbox.max_value = Alma.RANK_C[aspecto_atual]["limite_cargas"]
	ficha_habilidades_custo.text = "Você perderá [color=4a86e8]%s de sanidade" % custo
	ficha_habilidades_valor.text = "Valor por Carga: [color=%s]%s" % [cor, valor]
	ficha_habilidades_valormaximo.text = "[color=%s]Valor máximo: %s" % [cor, valormaximo]
	if aspecto_atual == "Minus":
		ficha_habilidades_acertomedo.text = "+%s (Medo*2)" % (token.stats["medo"]*2)
		ficha_habilidades_acertomedo.show()
	else:
		ficha_habilidades_acertomedo.hide()
	ficha_habilidades_acerto.text = "D20 + %s (%s)" % [TokensData.get_maior_atributo(token.stats).values()[0], TokensData.get_maior_atributo(token.stats).keys()[0]]

func _on_cargas_value_changed(value: float) -> void:
	cargas = int(value)
	definir_ficha()

func _on_check_button_toggled(toggled_on: bool) -> void:
	invertido = toggled_on
	definir_ficha()

func _on_rolar_cargas_pressed() -> void:
	var aspecto_atual = token.stats["aspecto"]
	if invertido:
		match aspecto_atual:
			"Polus":
				aspecto_atual = "Minus"
			"Minus":
				aspecto_atual = "Polus"
	if token.stats["sanidade"] >= custo:
		token.stats["sanidade"] -= custo
		token.spawn_charges.rpc(cargas, valor, 1, aspecto_atual)
		definir_ficha()
