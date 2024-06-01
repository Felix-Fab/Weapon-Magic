extends Control

@onready var MapSelect = $MapsSelect/MapContainer

func _process(_delta):
	MapSelect.get_node("Map" + str(Game.MapSelect)).grab_focus()

func _on_map_1_focus_entered():
	Game.MapSelect = 1

func _on_map_2_focus_entered():
	Game.MapSelect = 2

func _on_map_3_focus_entered():
	Game.MapSelect = 3

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Szenes/Maps/Map" + str(Game.MapSelect) +  ".tscn")
