extends Node

const RANK_ICONS = {
	"C" = preload("res://data/icons/rank-c-icon.png"),
	"C+" = preload("res://data/icons/rank-c-icon.png"),
	"B" = preload("res://data/icons/rank-b-icon.png"),
	"B+" = preload("res://data/icons/rank-b-icon.png"),
	"A" = preload("res://data/icons/rank-a-icon.png"),
	"S" = preload("res://data/icons/rank-a-icon.png"),
	"S+" = preload("res://data/icons/rank-a-icon.png"),
	"O" = preload("res://data/icons/rank-a-icon.png"),
}

var players = {
	"template" = {
		"id" = "",
		"name" = "",
		"icon" = null,
		"token_color" = Color(0.536, 0.275, 1.0, 1.0),
		"rank" = "",
		"race" = "",
		"foco" = "",
		"aspiration" = "",
		"aspecto" = "",
		
		"alma" = "",
		"fobia" = "",
		
		"credits" = 0,
		"limit" = 0,
		
		"morte" = 0,
		"max_morte" = 3,
		
		"medo" = 0,
		"max_medo" = 3,
		
		"vida" = 0,
		"max_vida" = 0,
		
		"vidatemp" = 0,
		"max_vidatemp" = 0,
		
		"sanidade" = 0,
		"max_sanidade" = 0,
		
		"postura" = 0,
		"max_postura" = 0,
		
		"resist_fisica" = 0,
		"resist_magica" = 0,
		
		"corpo" = 0,
		"destreza" = 0,
		"mente" = 0,
		"espirito" = 0,
		"carisma" = 0,
		
		"bonus_rank" = 0,
		"incrementos" = 0,
		"up_atributos" = 0,
		
		"pericias" = {
			"fisico" = {
				"furtividade" = {"value" = 0, "active" = false},
				"prestidigitacao" = {"value" = 0, "active" = false},
				"instinto" = {"value" = 0, "active" = false},
				"acrobacia" = {"value" = 0, "active" = false},
				"atletismo" = {"value" = 0, "active" = false},
				"adrenalina" = {"value" = 0, "active" = false},
				"rigidez" = {"value" = 0, "active" = false}
			},
			"social" = {
				"intimidacao" = {"value" = 0, "active" = false},
				"artes" = {"value" = 0, "active" = false},
				"persuasao" = {"value" = 0, "active" = false},
				"perspicacia" = {"value" = 0, "active" = false},
				"lidar_criaturas" = {"value" = 0, "active" = false},
				"encorajar" = {"value" = 0, "active" = false},
				"encantar" = {"value" = 0, "active" = false}
			},
			"mental" = {
				"aparelhagem" = {"value" = 0, "active" = false},
				"medicina" = {"value" = 0, "active" = false},
				"gastronomia" = {"value" = 0, "active" = false},
				"investigacao" = {"value" = 0, "active" = false},
				"criacao" = {"value" = 0, "active" = false},
				"coragem" = {"value" = 0, "active" = false},
				"sobrevivencia" = {"value" = 0, "active" = false}
			},
			"espiritual" = {
				"purificacao" = {"value" = 0, "active" = false},
				"ilusao" = {"value" = 0, "active" = false},
				"selo" = {"value" = 0, "active" = false},
				"bencao_maldicao" = {"value" = 0, "active" = false},
				"conjuracao" = {"value" = 0, "active" = false},
				"clarividencia" = {"value" = 0, "active" = false},
				"sobrecarga" = {"value" = 0, "active" = false}
			}
		}
	},
	
	"kauã" = {
		"id" = "kauã",
		"name" = "Kauã Orlando",
		"icon" = load("res://data/icons/kaua-icon.png"),
		"token_color" = Color(0.536, 0.275, 1.0, 1.0),
		"rank" = "B+",
		"race" = "Galvan",
		"foco" = "Marcial",
		"aspiration" = "Combate",
		"aspecto" = "Polus",
		
		"alma" = "Gongo",
		"fobia" = "???",
		
		"credits" = 0,
		"limit" = 0,
		
		"morte" = 2,
		"max_morte" = 3,
		
		"medo" = 1,
		"max_medo" = 3,
		
		"vida" = 201,
		"max_vida" = 300,
		
		"vidatemp" = 250,
		"max_vidatemp" = 300,
		
		"sanidade" = 10,
		"max_sanidade" = 12,
		
		"postura" = 1,
		"max_postura" = 90,
		
		"resist_fisica" = 110,
		"resist_magica" = 49,
		
		"corpo" = 0,
		"destreza" = 0,
		"mente" = 0,
		"espirito" = 0,
		"carisma" = 0,
		
		"bonus_rank" = 2,
		"incrementos" = 0,
		"up_atributos" = 0,
		
		"pericias" = {
			"fisico" = {
				"furtividade" = {"value" = 0, "active" = false},
				"prestidigitacao" = {"value" = 0, "active" = false},
				"instinto" = {"value" = 0, "active" = false},
				"acrobacia" = {"value" = 0, "active" = false},
				"atletismo" = {"value" = 0, "active" = false},
				"adrenalina" = {"value" = 0, "active" = false},
				"rigidez" = {"value" = 0, "active" = false}
			},
			"social" = {
				"intimidacao" = {"value" = 0, "active" = false},
				"artes" = {"value" = 0, "active" = false},
				"persuasao" = {"value" = 0, "active" = false},
				"perspicacia" = {"value" = 0, "active" = false},
				"lidar_criaturas" = {"value" = 0, "active" = false},
				"encorajar" = {"value" = 0, "active" = false},
				"encantar" = {"value" = 0, "active" = false}
			},
			"mental" = {
				"aparelhagem" = {"value" = 0, "active" = false},
				"medicina" = {"value" = 0, "active" = false},
				"gastronomia" = {"value" = 0, "active" = false},
				"investigacao" = {"value" = 0, "active" = false},
				"criacao" = {"value" = 0, "active" = false},
				"coragem" = {"value" = 0, "active" = false},
				"sobrevivencia" = {"value" = 0, "active" = false}
			},
			"espiritual" = {
				"purificacao" = {"value" = 0, "active" = false},
				"ilusao" = {"value" = 0, "active" = false},
				"selo" = {"value" = 0, "active" = false},
				"bencao_maldicao" = {"value" = 0, "active" = false},
				"conjuracao" = {"value" = 0, "active" = false},
				"clarividencia" = {"value" = 0, "active" = false},
				"sobrecarga" = {"value" = 0, "active" = false}
			}
		}
	},
}


func rank_up(token_id : String) -> void:
	const RANK_ORDER = ["C+", "B", "B+", "A", "S", "S+", "O"]
	const BONUS_RANK = [2, 4, 4, 8, 16, 32, 64]
	var token = players.get(token_id)
	var current_index = RANK_ORDER.find(token["rank"])
	if current_index != -1 and current_index < RANK_ORDER.size() - 1:
		token["rank"] = RANK_ORDER[current_index + 1]
		token["bonus_rank"] = BONUS_RANK[current_index + 1]

func increase_limit(token_id : String, amount: int) -> void:
	const RANKS = ["C", "C+", "B", "B+", "A", "S"]
	const INCREMENTOS = [1, 1, 1, 2, 4, 8]
	const LIMIT_THRESHOLD = [50, 150, 350, 850, 2500, 50000]
	var token = players.get(token_id)
	
	token["limit"] += amount
	token["credits"] += amount
	
	var current_rank_index = RANKS.find(token["rank"])
	if current_rank_index == -1:
		return
	
	var required_limit = LIMIT_THRESHOLD[current_rank_index]
	var incrementos_to_get = INCREMENTOS[current_rank_index]
	if token["limit"] >= required_limit:
		token["incrementos"] += incrementos_to_get
		token["up_atributos"] += incrementos_to_get
		if token["rank"] == "C" or token["rank"] == "B":
			token["rank"] = RANKS[current_rank_index + 1]
			return
		rank_up(token_id)
