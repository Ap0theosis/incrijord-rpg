class_name TokenData
extends Resource

# --- DADOS BÁSICOS ---
@export var id: String = ""
@export var nome: String = ""
@export var icone: Texture2D
@export var token_cor: Color = Color(0.536, 0.275, 1.0, 1.0)
@export_enum("C", "C+", "B", "B+", "A", "S", "S+", "O") var rank: String = "C"
@export_enum("Galvan", "Vampiro", "B", "B+", "A", "S", "S+", "O") var raca: String = ""
@export_enum("Selo", "Elemental", "Animal", "Mecânico", "Surya", "Marcial", "Natural", "Caçador") var foco: String = ""
@export_enum("Combate", "Inteligência", "Mantra") var aspiracao: String = ""
@export_enum(
	"Armas Longo-alcance", "Armas Leves", "Armas Pesadas", "Armas de Haste", "Espadachim", "Lutador",
	"Armas", "Ferramentas Medicinais", "Explosivos", "Robôs", "Ferramentas Diversas", "Veículos",
	"Ofensivo", "Controlador", "Curandeiro", "Tático", "Caótico", "Muralha",
	) var especializacao: String = ""
@export_enum("Polus", "Minus") var aspecto: String = ""
@export var alma: String = ""
@export var fobia: String = ""

# --- RECURSOS E LIMITES ---
@export var creditos: int = 0
@export var limite: int = 0
@export var morte: int = 0
@export var max_morte: int = 3
@export var medo: int = 0
@export var max_medo: int = 3

# --- PONTOS DE VIDA / SANIDADE / POSTURA ---
@export var vida: int = 0
@export var max_vida: int = 0
@export var vidatemp: int = 0
@export var max_vidatemp: int = 0
@export var sanidade: int = 0
@export var max_sanidade: int = 0
@export var postura: int = 0
@export var max_postura: int = 0

# --- RESISTÊNCIAS E ATRIBUTOS ---
@export var resist_fisica: int = 0
@export var resist_magica: int = 0

@export_group("Atributos")
@export var corpo: int = 0
@export var destreza: int = 0
@export var mente: int = 0
@export var espirito: int = 0
@export var carisma: int = 0

@export_group("Evolução")
@export var bonus_rank: int = 0
@export var incrementos: int = 0
@export var up_atributos: int = 0

# --- PERÍCIAS ---
@export var pericias: Dictionary = {
	"fisico": {
		"furtividade": {"value": 0, "active": false},
		"prestidigitacao": {"value": 0, "active": false},
		"instinto": {"value": 0, "active": false},
		"acrobacia": {"value": 0, "active": false},
		"atletismo": {"value": 0, "active": false},
		"adrenalina": {"value": 0, "active": false},
		"rigidez": {"value": 0, "active": false}
	},
	"social": {
		"intimidacao": {"value": 0, "active": false},
		"artes": {"value": 0, "active": false},
		"persuasao": {"value": 0, "active": false},
		"perspicacia": {"value": 0, "active": false},
		"lidar_criaturas": {"value": 0, "active": false},
		"encorajar": {"value": 0, "active": false},
		"encantar": {"value": 0, "active": false}
	},
	"mental": {
		"aparelhagem": {"value": 0, "active": false},
		"medicina": {"value": 0, "active": false},
		"gastronomia": {"value": 0, "active": false},
		"investigacao": {"value": 0, "active": false},
		"criacao": {"value": 0, "active": false},
		"coragem": {"value": 0, "active": false},
		"sobrevivencia": {"value": 0, "active": false}
	},
	"espiritual": {
		"purificacao": {"value": 0, "active": false},
		"ilusao": {"value": 0, "active": false},
		"selo": {"value": 0, "active": false},
		"bencao_maldicao": {"value": 0, "active": false},
		"conjuracao": {"value": 0, "active": false},
		"clarividencia": {"value": 0, "active": false},
		"sobrecarga": {"value": 0, "active": false}
	}
}

@export var artefatos : Dictionary = {}

@export var habilidades_raca : Dictionary = {}
@export var habilidades_foco : Dictionary = {}
@export_enum("Bestial", "Aparato", "Cataclismo") var tipo_fobia : String = ""
@export var habilidades_fobia : Dictionary = {}

@export var habilidades_c : int = 0
@export var habilidades_secundarias : int = 0
@export var habilidades_b : int = 0
@export var habilidades_a : int = 0
@export var habilidades_s : int = 0
@export var habilidades_lendaria : int = 0

@export var anotacao : String = ""
# --- FUNÇÕES DE LÓGICA DO PERSONAGEM (Embutidas no Resource!) ---

func rank_up() -> void:
	const RANK_ORDER = ["C+", "B", "B+", "A", "S", "S+", "O"]
	const BONUS_RANK = [2, 4, 4, 8, 16, 32, 64]
	var current_index = RANK_ORDER.find(rank)
	if current_index != -1 and current_index < RANK_ORDER.size() - 1:
		rank = RANK_ORDER[current_index + 1]
		bonus_rank = BONUS_RANK[current_index + 1]

func increase_limit(amount: int) -> void:
	const RANKS = ["C", "C+", "B", "B+", "A", "S"]
	const INCREMENTOS = [1, 1, 1, 2, 4, 8]
	const LIMITE_LIMIAR = [50, 150, 350, 850, 2500, 50000]
	
	limite += amount
	creditos += amount
	
	var current_rank_index = RANKS.find(rank)
	if current_rank_index == -1:
		return
	
	var required_limit = LIMITE_LIMIAR[current_rank_index]
	var incrementos_to_get = INCREMENTOS[current_rank_index]
	if limite >= required_limit:
		incrementos += incrementos_to_get
		up_atributos += incrementos_to_get
		if rank == "C" or rank == "B":
			rank = RANKS[current_rank_index + 1]
			return
		rank_up()

func get_maior_atributo():
	var atributos = {}
	atributos.set("Corpo", corpo)
	atributos.set("Destreza", destreza)
	atributos.set("Mente", mente)
	atributos.set("Espirito", espirito)
	atributos.set("Carisma", carisma)
	var maior_atributo_final = {}
	var atributos_value =  atributos.values()
	atributos_value.sort()
	var maior_atributo_value = atributos_value[-1]
	maior_atributo_final.set(atributos.find_key(maior_atributo_value), maior_atributo_value)
	return maior_atributo_final
