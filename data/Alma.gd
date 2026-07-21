extends Node

const RANK_C = {
	"Polus" = {
		"custo_final" = 0,
		"limite_cargas" = 1,
		"valor_cargas" = 6,
		"acerto" = "D20 + Maior Atributo",
		"critico" = 1,
		"cor" = "ff9900",
		"bonus" = "+2 cura e proteção"
	},
	"Minus" = {
		"custo_final" = 1,
		"limite_cargas" = 4,
		"valor_cargas" = 4,
		"acerto" = "D20 + Maior Atributo + 2x Medo",
		"critico" = 1,
		"cor" = "ff0000",
		"bonus" = "+4 destruição"
	},
	"Minimos" = {
		"Força" = 2,
		"Alcance" = 2,
		"Duração" = 2
	}
}

const RANK_B = {
	"Polus" = {
		"custo_final" = 0,
		"limite_cargas" = 3,# 6 12 18 24 30 36 42 48 54 -9
		"valor_cargas" = 6, # 8 16    24 32 40    48 -9
		"acerto" = "D20 + Maior Atributo",
		"critico" = 1.5,
		"cor" = "ff9900",
		"bonus" = "+4 cura e proteção"
	},
	"Minus" = {
		"custo_final" = 3,
		"limite_cargas" = 6,
		"valor_cargas" = 8,
		"acerto" = "D20 + Maior Atributo + 4x Medo",
		"critico" = 1.5,
		"cor" = "ff0000",
		"bonus" = "+4 destruição"
	},
	"Minimos" = {
		"Força" = 4,
		"Alcance" = 4,
		"Duração" = 2
	}
}
