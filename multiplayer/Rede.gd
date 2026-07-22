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

func _on_peer_connected(id: int):
	print("Jogador com ID ", id, " entrou na partida!")
	if multiplayer.is_server():
		adicionar_jogador(id)
		await get_tree().create_timer(0.5).timeout
		sincronizar_todos_os_tokens.rpc_id(id)
	
	if not multiplayer.is_server():
		await get_tree().create_timer(0.5).timeout
		return
	await get_tree().create_timer(0.5).timeout
	
	# O Host lê o estado de cada token e envia um pacote customizado para o novo cliente
	for token_node in get_tree().current_scene.tokens_node.get_children():
		if token_node.stats:
			var stats: TokenData = token_node.stats
			
			# Montamos os dados básicos e numéricos
			var dados_token = {
				"nome": stats.nome,
				"rank": stats.rank,
				"raca": stats.raca,
				"foco": stats.foco,
				"aspecto": stats.aspecto,
				"alma": stats.alma,
				"fobia": stats.fobia,
				"token_cor": stats.token_cor,
				"vida": stats.vida,
				"max_vida": stats.max_vida,
				"sanidade": stats.sanidade,
				"max_sanidade": stats.max_sanidade,
				"postura": stats.postura,
				"max_postura": stats.max_postura,
				"medo": stats.medo,
				"morte": stats.morte,
				"corpo": stats.corpo,
				"destreza": stats.destreza,
				"mente": stats.mente,
				"espirito": stats.espirito,
				"carisma": stats.carisma,
				"pericias": stats.pericias
			}
			
			# Envia os dados deste token específico para o id do novo jogador
			aplicar_estado_token.rpc_id(id, token_node.get_path(), dados_token)


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

@rpc("authority", "call_remote", "reliable")
func sincronizar_todos_os_tokens() -> void:
	# Este código roda EXCLUSIVAMENTE na máquina do jogador que acabou de conectar!
	var tokens_na_cena = get_tree().get_nodes_in_group("tokens")
	
	for token_node in tokens_na_cena:
		if not token_node.stats:
			continue
			
		
		token_node.apply_hex_color()

@rpc("authority", "call_remote", "reliable")
func aplicar_estado_token(token_path: NodePath, dados: Dictionary) -> void:
	# O novo cliente recebe o caminho do token e preenche o Resource dele na máquina dele
	var token_node = get_node_or_null(token_path)
	if token_node and token_node.stats:
		var stats: TokenData = token_node.stats
		
		# Injeta todas as propriedades recebidas
		for chave in dados:
			stats.set(chave, dados[chave])
			
		# Atualiza o visual e a Ficha no cliente
		token_node.update_hud.rpc()
		token_node.apply_hex_color()
