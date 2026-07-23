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
	"yonnahu": preload("res://data/tokens/yonnahu.tres"),
	"kaua": preload("res://data/tokens/kaua.tres")
	
	#"template" = {
		#"id" = "",
		#"name" = "",
		#"icon" = null,
		#"token_color" = Color(0.536, 0.275, 1.0, 1.0),
		#"rank" = "",
		#"race" = "",
		#"foco" = "",
		#"aspiration" = {"Nada": "Nadinha"},
		#"aspecto" = "",
		#
		#"alma" = "",
		#"fobia" = "",
		#
		#"credits" = 0,
		#"limit" = 0,
		#
		#"morte" = 0,
		#"max_morte" = 3,
		#
		#"medo" = 0,
		#"max_medo" = 3,
		#
		#"vida" = 0,
		#"max_vida" = 0,
		#
		#"vidatemp" = 0,
		#"max_vidatemp" = 0,
		#
		#"sanidade" = 0,
		#"max_sanidade" = 0,
		#
		#"postura" = 0,
		#"max_postura" = 0,
		#
		#"resist_fisica" = 0,
		#"resist_magica" = 0,
		#
		#"corpo" = 0,
		#"destreza" = 0,
		#"mente" = 0,
		#"espirito" = 0,
		#"carisma" = 0,
		#
		#"bonus_rank" = 0,
		#"incrementos" = 0,
		#"up_atributos" = 0,
		#
		#"pericias" = {
			#"fisico" = {
				#"furtividade" = {"value" = 0, "active" = false},
				#"prestidigitacao" = {"value" = 0, "active" = false},
				#"instinto" = {"value" = 0, "active" = false},
				#"acrobacia" = {"value" = 0, "active" = false},
				#"atletismo" = {"value" = 0, "active" = false},
				#"adrenalina" = {"value" = 0, "active" = false},
				#"rigidez" = {"value" = 0, "active" = false}
			#},
			#"social" = {
				#"intimidacao" = {"value" = 0, "active" = false},
				#"artes" = {"value" = 0, "active" = false},
				#"persuasao" = {"value" = 0, "active" = false},
				#"perspicacia" = {"value" = 0, "active" = false},
				#"lidar_criaturas" = {"value" = 0, "active" = false},
				#"encorajar" = {"value" = 0, "active" = false},
				#"encantar" = {"value" = 0, "active" = false}
			#},
			#"mental" = {
				#"aparelhagem" = {"value" = 0, "active" = false},
				#"medicina" = {"value" = 0, "active" = false},
				#"gastronomia" = {"value" = 0, "active" = false},
				#"investigacao" = {"value" = 0, "active" = false},
				#"criacao" = {"value" = 0, "active" = false},
				#"coragem" = {"value" = 0, "active" = false},
				#"sobrevivencia" = {"value" = 0, "active" = false}
			#},
			#"espiritual" = {
				#"purificacao" = {"value" = 0, "active" = false},
				#"ilusao" = {"value" = 0, "active" = false},
				#"selo" = {"value" = 0, "active" = false},
				#"bencao_maldicao" = {"value" = 0, "active" = false},
				#"conjuracao" = {"value" = 0, "active" = false},
				#"clarividencia" = {"value" = 0, "active" = false},
				#"sobrecarga" = {"value" = 0, "active" = false}
			#}
		#}
	#},
	#
	#"kauã" = {
		#"id" = "kauã",
		#"name" = "Kauã Orlando",
		#"icon" = load("res://data/icons/kaua-icon.png"),
		#"token_color" = Color(0.536, 0.275, 1.0, 1.0),
		#"rank" = "B+",
		#"race" = "Vampiro",
		#"foco" = "Marcial",
		#"aspiration" = {"Combate": "Nadinha"},
		#"aspecto" = "Minus",
		#
		#"alma" = "Gongo",
		#"fobia" = "???",
		#
		#"credits" = 0,
		#"limit" = 0,
		#
		#"morte" = 2,
		#"max_morte" = 3,
		#
		#"medo" = 1,
		#"max_medo" = 3,
		#
		#"vida" = 201,
		#"max_vida" = 300,
		#
		#"vidatemp" = 250,
		#"max_vidatemp" = 300,
		#
		#"sanidade" = 900,
		#"max_sanidade" = 12,
		#
		#"postura" = 1,
		#"max_postura" = 90,
		#
		#"resist_fisica" = 110,
		#"resist_magica" = 49,
		#
		#"corpo" = 6,
		#"destreza" = 6,
		#"mente" = 3,
		#"espirito" = 2,
		#"carisma" = 7,
		#
		#"bonus_rank" = 2,
		#"incrementos" = 0,
		#"up_atributos" = 0,
		#
		#"pericias" = {
			#"fisico" = {
				#"furtividade" = {"value" = 0, "active" = false},
				#"prestidigitacao" = {"value" = 0, "active" = false},
				#"instinto" = {"value" = 0, "active" = false},
				#"acrobacia" = {"value" = 0, "active" = false},
				#"atletismo" = {"value" = 0, "active" = false},
				#"adrenalina" = {"value" = 0, "active" = false},
				#"rigidez" = {"value" = 0, "active" = false}
			#},
			#"social" = {
				#"intimidacao" = {"value" = 0, "active" = false},
				#"artes" = {"value" = 0, "active" = false},
				#"persuasao" = {"value" = 0, "active" = false},
				#"perspicacia" = {"value" = 0, "active" = false},
				#"lidar_criaturas" = {"value" = 0, "active" = false},
				#"encorajar" = {"value" = 0, "active" = false},
				#"encantar" = {"value" = 0, "active" = false}
			#},
			#"mental" = {
				#"aparelhagem" = {"value" = 0, "active" = false},
				#"medicina" = {"value" = 0, "active" = false},
				#"gastronomia" = {"value" = 0, "active" = false},
				#"investigacao" = {"value" = 0, "active" = false},
				#"criacao" = {"value" = 0, "active" = false},
				#"coragem" = {"value" = 0, "active" = false},
				#"sobrevivencia" = {"value" = 0, "active" = false}
			#},
			#"espiritual" = {
				#"purificacao" = {"value" = 0, "active" = false},
				#"ilusao" = {"value" = 0, "active" = false},
				#"selo" = {"value" = 0, "active" = false},
				#"bencao_maldicao" = {"value" = 0, "active" = false},
				#"conjuracao" = {"value" = 0, "active" = false},
				#"clarividencia" = {"value" = 0, "active" = false},
				#"sobrecarga" = {"value" = 0, "active" = false}
			#}
		#}
	#},
	#
	#"cain" = {
		#"id" = "cain",
		#"name" = "Cain",
		#"icon" = load("res://data/icons/cain-icon.png"),
		#"token_color" = Color(0.861, 0.0, 0.501, 1.0),
		#"rank" = "B",
		#"race" = "Shiver",
		#"foco" = "Selo",
		#"aspiration" = {"Mantra": "Caótico"},
		#"aspecto" = "Minus",
		#
		#"alma" = "Sentimentos",
		#"fobia" = "Guerra",
		#
		#"credits" = 150,
		#"limit" = 150,
		#
		#"morte" = 1,
		#"max_morte" = 3,
		#
		#"medo" = 1,
		#"max_medo" = 4,
		#
		#"vida" = 44,
		#"max_vida" = 44,
		#
		#"vidatemp" = 0,
		#"max_vidatemp" = 44,
		#
		#"sanidade" = 21,
		#"max_sanidade" = 33,
		#
		#"postura" = 0,
		#"max_postura" = 0,
		#
		#"resist_fisica" = 7,
		#"resist_magica" = 10,
		#
		#"corpo" = 0,
		#"destreza" = 0,
		#"mente" = 1,
		#"espirito" = 4,
		#"carisma" = 4,
		#
		#"bonus_rank" = 0,
		#"incrementos" = 0,
		#"up_atributos" = 0,
		#
		#"pericias" = {
			#"fisico" = {
				#"furtividade" = {"value" = 0, "active" = false},
				#"prestidigitacao" = {"value" = 0, "active" = false},
				#"instinto" = {"value" = 0, "active" = false},
				#"acrobacia" = {"value" = 4, "active" = true},
				#"atletismo" = {"value" = 0, "active" = false},
				#"adrenalina" = {"value" = 0, "active" = false},
				#"rigidez" = {"value" = 0, "active" = false}
			#},
			#"social" = {
				#"intimidacao" = {"value" = 4, "active" = true},
				#"artes" = {"value" = 0, "active" = false},
				#"persuasao" = {"value" = 4, "active" = true},
				#"perspicacia" = {"value" = 0, "active" = false},
				#"lidar_criaturas" = {"value" = 0, "active" = false},
				#"encorajar" = {"value" = 0, "active" = false},
				#"encantar" = {"value" = 0, "active" = false}
			#},
			#"mental" = {
				#"aparelhagem" = {"value" = 0, "active" = false},
				#"medicina" = {"value" = 6, "active" = true},
				#"gastronomia" = {"value" = 0, "active" = false},
				#"investigacao" = {"value" = 4, "active" = true},
				#"criacao" = {"value" = 0, "active" = false},
				#"coragem" = {"value" = 0, "active" = false},
				#"sobrevivencia" = {"value" = 0, "active" = false}
			#},
			#"espiritual" = {
				#"purificacao" = {"value" = 0, "active" = false},
				#"ilusao" = {"value" = 4, "active" = true},
				#"selo" = {"value" = 6, "active" = true},
				#"bencao_maldicao" = {"value" = 0, "active" = false},
				#"conjuracao" = {"value" = 0, "active" = false},
				#"clarividencia" = {"value" = 0, "active" = false},
				#"sobrecarga" = {"value" = 4, "active" = true}
			#}
		#}
	#},
#
	#"shield" = {
		#"id" = "shield",
		#"name" = "S.H.I.E.L.D",
		#"icon" = load("res://data/icons/shield-icon.jpg"),
		#"token_color" = Color(0.844, 0.641, 0.0, 1.0),
		#"rank" = "C",
		#"race" = "AT4K",
		#"foco" = "Marcial",
		#"aspiration" = {"Combate": "Lutador"},
		#"aspecto" = "Polus",
		#
		#"alma" = "Sucata",
		#"fobia" = "Esquecimento",
		#
		#"credits" = 90,
		#"limit" = 90,
		#
		#"morte" = 0,
		#"max_morte" = 3,
		#
		#"medo" = 0,
		#"max_medo" = 3,
		#
		#"vida" = 34,
		#"max_vida" = 34,
		#
		#"vidatemp" = 0,
		#"max_vidatemp" = 34,
		#
		#"sanidade" = 12,
		#"max_sanidade" = 12,
		#
		#"postura" = 9,
		#"max_postura" = 9,
		#
		#"resist_fisica" = 14,
		#"resist_magica" = 14,
		#
		#"corpo" = 5,
		#"destreza" = 1,
		#"mente" = 1,
		#"espirito" = 1,
		#"carisma" = 1,
		#
		#"bonus_rank" = 0,
		#"incrementos" = 0,
		#"up_atributos" = 0,
		#
		#"pericias" = {
			#"fisico" = {
				#"furtividade" = {"value" = 0, "active" = false},
				#"prestidigitacao" = {"value" = 0, "active" = false},
				#"instinto" = {"value" = 2, "active" = true},
				#"acrobacia" = {"value" = 0, "active" = false},
				#"atletismo" = {"value" = 2, "active" = true},
				#"adrenalina" = {"value" = 2, "active" = true},
				#"rigidez" = {"value" = 2, "active" = true}
			#},
			#"social" = {
				#"intimidacao" = {"value" = 3, "active" = true},
				#"artes" = {"value" = 0, "active" = false},
				#"persuasao" = {"value" = 0, "active" = false},
				#"perspicacia" = {"value" = 0, "active" = false},
				#"lidar_criaturas" = {"value" = 0, "active" = false},
				#"encorajar" = {"value" = 0, "active" = false},
				#"encantar" = {"value" = 0, "active" = false}
			#},
			#"mental" = {
				#"aparelhagem" = {"value" = 0, "active" = false},
				#"medicina" = {"value" = 0, "active" = false},
				#"gastronomia" = {"value" = 0, "active" = false},
				#"investigacao" = {"value" = 0, "active" = false},
				#"criacao" = {"value" = 0, "active" = false},
				#"coragem" = {"value" = 0, "active" = false},
				#"sobrevivencia" = {"value" = 0, "active" = false}
			#},
			#"espiritual" = {
				#"purificacao" = {"value" = 0, "active" = false},
				#"ilusao" = {"value" = 0, "active" = false},
				#"selo" = {"value" = 0, "active" = false},
				#"bencao_maldicao" = {"value" = 0, "active" = false},
				#"conjuracao" = {"value" = 0, "active" = false},
				#"clarividencia" = {"value" = 0, "active" = false},
				#"sobrecarga" = {"value" = 2, "active" = true}
			#}
		#}
	#},
#
	#"zincflinc" = {
		#"id" = "zincflinc",
		#"name" = "Zinc e Flinc",
		#"icon" = load("res://data/icons/shield-icon.jpg"),
		#"token_color" = Color(0.844, 0.641, 0.0, 1.0),
		#"rank" = "C",
		#"race" = "Exo-galvan",
		#"foco" = "Mecânico",
		#"aspiration" = {"Inteligência": "Robôs"},
		#"aspecto" = "Polus",
		#
		#"alma" = "Atrito e Filigrana",
		#"fobia" = "Solidão",
		#
		#"credits" = 90,
		#"limit" = 90,
		#
		#"morte" = 0,
		#"max_morte" = 3,
		#
		#"medo" = 0,
		#"max_medo" = 3,
		#
		#"vida" = 24,
		#"max_vida" = 24,
		#
		#"vidatemp" = 0,
		#"max_vidatemp" = 24,
		#
		#"sanidade" = 30,
		#"max_sanidade" = 30,
		#
		#"postura" = 0,
		#"max_postura" = 0,
		#
		#"resist_fisica" = 10,
		#"resist_magica" = 10,
		#
		#"corpo" = 0,
		#"destreza" = 3,
		#"mente" = 5,
		#"espirito" = 0,
		#"carisma" = 2,
		#
		#"bonus_rank" = 0,
		#"incrementos" = 0,
		#"up_atributos" = 0,
		#
		#"pericias" = {
			#"fisico" = {
				#"furtividade" = {"value" = 0, "active" = false},
				#"prestidigitacao" = {"value" = 2, "active" = true},
				#"instinto" = {"value" = 0, "active" = false},
				#"acrobacia" = {"value" = 2, "active" = true},
				#"atletismo" = {"value" = 0, "active" = false},
				#"adrenalina" = {"value" = 0, "active" = false},
				#"rigidez" = {"value" = 0, "active" = false}
			#},
			#"social" = {
				#"intimidacao" = {"value" = 0, "active" = false},
				#"artes" = {"value" = 0, "active" = false},
				#"persuasao" = {"value" = 0, "active" = false},
				#"perspicacia" = {"value" = 0, "active" = false},
				#"lidar_criaturas" = {"value" = 0, "active" = false},
				#"encorajar" = {"value" = 0, "active" = false},
				#"encantar" = {"value" = 0, "active" = false}
			#},
			#"mental" = {
				#"aparelhagem" = {"value" = 2, "active" = true},
				#"medicina" = {"value" = 0, "active" = false},
				#"gastronomia" = {"value" = 2, "active" = true},
				#"investigacao" = {"value" = 5, "active" = true},
				#"criacao" = {"value" = 2, "active" = true},
				#"coragem" = {"value" = 0, "active" = false},
				#"sobrevivencia" = {"value" = 0, "active" = false}
			#},
			#"espiritual" = {
				#"purificacao" = {"value" = 0, "active" = false},
				#"ilusao" = {"value" = 0, "active" = false},
				#"selo" = {"value" = 0, "active" = false},
				#"bencao_maldicao" = {"value" = 0, "active" = false},
				#"conjuracao" = {"value" = 2, "active" = true},
				#"clarividencia" = {"value" = 0, "active" = false},
				#"sobrecarga" = {"value" = 0, "active" = false}
			#}
		#}
	#},
}
