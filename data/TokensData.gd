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
	},
}
