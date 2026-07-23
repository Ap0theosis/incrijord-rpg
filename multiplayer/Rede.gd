extends Node

const PORT = 8080
var ADDRESS = "127.0.0.1"

const PLAYER_CAM = preload("res://multiplayer/player_cam.tscn")
const SINGLE_CAM = preload("res://multiplayer/single_cam.tscn")

var spawn_node = null

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)

func criar_host():
	var peer = ENetMultiplayerPeer.new()
	
	var error = peer.create_server(PORT)
	if error != OK:
		print("Erro ao criar host: ", error)
		return
	
	multiplayer.multiplayer_peer = peer
	print("Host criado!")
	
	iniciar_partida()
	await get_tree().create_timer(0.1).timeout
	spawn_node = get_tree().current_scene.get_node("Players")
	adicionar_jogador(1)

func conectar_ao_host():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(ADDRESS, PORT)
	if error != OK:
		print("Erro ao conectar: ", error)
		return
	
	multiplayer.multiplayer_peer = peer
	print("Conectando ao IP: ", ADDRESS, " na porta: ", PORT)

func _on_peer_connected(id: int) -> void:
	if not multiplayer.is_server():
		return
	
	print("Jogador com ID ", id, " entrou na partida!")
	
	adicionar_jogador(id)
	
	await get_tree().create_timer(0.5).timeout
	
	for token_node in get_tree().current_scene.tokens_node.get_children():
		transmitir_token(token_node, id)


func _on_peer_disconnected(id: int):
	print("Jogador com ID ", id, " desconectou.")
	if multiplayer.is_server():
		remover_jogador(id)

func _on_connected_to_server():
	print("Sucesso! Conectado ao servidor.")
	iniciar_partida()

func _on_connection_failed():
	print("Falha na conexão! O servidor está offline ou o IP/Porta estão errados.")
	multiplayer.multiplayer_peer = null

func iniciar_partida():
	get_tree().change_scene_to_file("res://main.tscn")

func adicionar_jogador(id: int):
	var new_player = PLAYER_CAM.instantiate()
	new_player.player_id = id
	new_player.name = str(id)
	spawn_node.add_child(new_player, true)

func remover_jogador(id: int):
	if not spawn_node.has_node(str(id)):
		return
	spawn_node.get_node(str(id)).queue_free()

func single_player() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
	await get_tree().create_timer(0.1).timeout
	spawn_node = get_tree().current_scene.get_node("Players")
	var new_player = SINGLE_CAM.instantiate()
	spawn_node.add_child(new_player)

func transmitir_token(token_node: Node2D, target_peer_id: int = 0) -> void:
	if not (multiplayer.is_server() and token_node and token_node.stats):
		return

	var stats: TokenData = token_node.stats

	# Monta o pacote com todo o Resource do Host
	var dados_token = {
		"nome": stats.nome,
		"icone": stats.icone,
		"token_cor": stats.token_cor,
		"rank": stats.rank,
		"raca": stats.raca,
		"foco": stats.foco,
		"aspiracao": stats.aspiracao,
		"especializacao": stats.especializacao,
		"aspecto": stats.aspecto,
		"alma": stats.alma,
		"fobia": stats.fobia,
		"creditos": stats.creditos,
		"limite": stats.limite,
		"medo": stats.medo,
		"max_medo": stats.max_medo,
		"morte": stats.morte,
		"max_morte": stats.max_morte,
		"vida": stats.vida,
		"max_vida": stats.max_vida,
		"vidatemp": stats.vidatemp,
		"max_vidatemp": stats.max_vidatemp,
		"sanidade": stats.sanidade,
		"max_sanidade": stats.max_sanidade,
		"postura": stats.postura,
		"max_postura": stats.max_postura,
		"corpo": stats.corpo,
		"destreza": stats.destreza,
		"mente": stats.mente,
		"espirito": stats.espirito,
		"carisma": stats.carisma,
		"resist_fisica": stats.resist_fisica,
		"resist_magica": stats.resist_magica,
		"bonus_rank": stats.bonus_rank,
		"incrementos": stats.incrementos,
		"up_atributos": stats.up_atributos,
		"pericias": stats.pericias,
		"artefatos": stats.artefatos,
		"habilidades_raca": stats.habilidades_raca,
		"habilidades_foco": stats.habilidades_foco,
		"tipo_fobia": stats.tipo_fobia,
		"habilidades_fobia": stats.habilidades_fobia,
		"habilidades_c": stats.habilidades_c,
		"habilidades_secundarias": stats.habilidades_secundarias,
		"habilidades_b": stats.habilidades_b,
		"habilidades_a": stats.habilidades_a,
		"habilidades_s": stats.habilidades_s,
		"habilidades_lendaria": stats.habilidades_lendaria,
		"anotacao": stats.anotacao
	}

	# Se informou um ID específico (ex: novo player), manda só pra ele. 
	# Se for 0, manda para todo mundo!
	if target_peer_id != 0:
		aplicar_estado_token.rpc_id(target_peer_id, token_node.get_path(), dados_token)
	else:
		aplicar_estado_token.rpc(token_node.get_path(), dados_token)

@rpc("any_peer", "call_remote", "reliable")
func sincronizar_todos_os_tokens() -> void:
	var tokens_na_cena = get_tree().get_nodes_in_group("tokens")
	
	for token_node in tokens_na_cena:
		if not token_node.stats:
			continue
		
		token_node.apply_hex_color()

@rpc("any_peer", "call_local", "reliable")
func aplicar_estado_token(token_path: NodePath, dados: Dictionary) -> void:
	var token_node = get_node_or_null(token_path)
	
	if token_node and token_node.stats:
		# Injeta todas as variáveis recebidas no Resource da máquina local
		for chave in dados:
			token_node.stats.set(chave, dados[chave])
			
		# Atualiza os visuais e a Ficha na tela de quem está vendo
		token_node.apply_hex_color()
		token_node.update_hud()
		
