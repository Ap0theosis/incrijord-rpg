extends Node

func salvar_ficha(stats: TokenData) -> void:
	if not multiplayer.is_server():
		return
	
	if not stats or stats.id.is_empty():
		push_error("Tentativa de salvar um TokenData inválido ou sem ID.")
		return
		
	DirAccess.make_dir_absolute("user://fichas")
	
	var caminho = "user://fichas/" + stats.id + ".tres"
	var erro = ResourceSaver.save(stats, caminho)
	
	if erro == OK:
		print("✅ Ficha de '", stats.id, "' salva com sucesso em: ", caminho)
	else:
		push_error("Erro ao salvar a ficha: " + str(erro))

func carregar_ficha(id: String) -> TokenData:
	if not multiplayer.is_server():
		return
	var caminho = "user://fichas/" + id + ".tres"
	
	if ResourceLoader.exists(caminho):
		var dados = ResourceLoader.load(caminho).duplicate() as TokenData
		print("📂 Ficha de '", id, "' carregada com sucesso!")
		return dados
	else:
		print("⚠️ Nenhum save encontrado em: ", caminho)
		return null
