extends Control

@onready var PlayerSelect = $PlayerSelect

func _process(delta):
	PlayerSelect.play("Player" + str(Game.PlayerSelect))

func _on_left_button_pressed():
	if Game.PlayerSelect > 1:
		Game.PlayerSelect -= 1

func _on_right_button_pressed():
	if Game.PlayerSelect < 5:
		Game.PlayerSelect += 1

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Szenes/Pages/WeaponSelection.tscn")