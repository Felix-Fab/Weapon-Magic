extends Node

func _process(delta):
	match Game.PlayerSelect:
		1: get_node("PlayerSelect").play("Player1")
		2: get_node("PlayerSelect").play("Player2")
		3: get_node("PlayerSelect").play("Player3")
		4: get_node("PlayerSelect").play("Player4")
		5: get_node("PlayerSelect").play("Player5")
		

func _on_left_button_pressed():
	if Game.PlayerSelect > 1:
		Game.PlayerSelect -= 1

func _on_right_button_pressed():
	if Game.PlayerSelect < 5:
		Game.PlayerSelect += 1

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Szenes/Maps/Start.tscn")
