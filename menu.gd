extends Control

func _on_host_pressed():
	Rede.criar_host()

func _on_join_pressed():
	Rede.conectar_ao_host()
