extends Node

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
		"rank" = "C",
		"race" = "Galvan",
		"foco" = "Marcial",
		"aspiration" = "Combate",
		"aspecto" = "Polus",
		
		"alma" = "Gongo",
		"fobia" = "???",
		
		"credits" = 350,
		"limit" = 850,
		
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
		
		"bonus_rank" = 0,
		"incrementos" = 0,
		
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
