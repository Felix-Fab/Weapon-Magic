extends Control

@onready var WeaponSelect = $WeaponSelect/WeaponSelect
@onready var SkillSelect = $SkillsSelect/SkillContainer

func _process(delta):
	WeaponSelect.play("Weapon" + str(Game.WeaponSelect))
	SkillSelect.get_node("Skill" + str(Game.SkillSelect)).grab_focus()

func _on_weapon_left_button_pressed():
	if Game.WeaponSelect > 1:
		Game.WeaponSelect -= 1

func _on_weapon_right_button_pressed():
	if Game.WeaponSelect < 3:
		Game.WeaponSelect += 1
	
func _on_skill_1_focus_entered():
	Game.SkillSelect = 1

func _on_skill_2_focus_entered():
	Game.SkillSelect = 2

func _on_skill_3_focus_entered():
	Game.SkillSelect = 3

func _on_skill_4_focus_entered():
	Game.SkillSelect = 4

func _on_next_pressed():
	get_tree().change_scene_to_file("res://Szenes/Pages/MapSelection.tscn")
