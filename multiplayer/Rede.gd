extends Node

const PORT = 8080
const ADDRESS = "127.0.0.1"
const PLAYER_CAM = preload("res://multiplayer/player_cam.tscn")

var spawn_node = null

func _on_peer_connected(id):
	print("Jogador com ID ", id, " entrou na partida!")
	if multiplayer.is_server():
		adicionar_jogador(id)

func criar_host():
	
	var peer = ENetMultiplayerPeer.new()
	
	var error = peer.create_server(PORT)
	if error != OK:
		print("Erro ao criar host: ", error)
		return
	
	multiplayer.multiplayer_peer = peer
	print("Host criado!")
	
	multiplayer.peer_connected.connect(adicionar_jogador)
	#multiplayer.peer_disconnected.connect(remover_jogador)
	
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
	print("Tentando se conectar ao host...")
	iniciar_partida()

func iniciar_partida():
	get_tree().change_scene_to_file("res://main.tscn")

func adicionar_jogador(id: int):
	print("Player %s joined the game!" % id)
	var new_player = PLAYER_CAM.instantiate()
	new_player.player_id = id
	new_player.name = str(id)
	spawn_node.add_child(new_player, true)
	
	
	
	
	
	
	#if not multiplayer.is_server(): 
		#return
	#
	#await get_tree().create_timer(0.1).timeout
	#var cena_main = get_tree().current_scene
	#print(cena_main)
	#if cena_main and cena_main.has_node("Players"):
		#var no_players = cena_main.get_node("Players")
		#if no_players.has_node(str(id)):
			#return
		#var nova_camera = preload("res://multiplayer/player_cam.tscn").instantiate()
		#nova_camera.name = str(id)
		#no_players.add_child(nova_camera)
		#print("Câmera do jogador ", id, " adicionada com sucesso em main/Players!")
	#else:
		#print("ERRO: Nó 'Players' não foi encontrado na cena atual!")
