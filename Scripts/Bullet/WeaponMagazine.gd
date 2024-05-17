extends Node2D

var MagazinSpace = Weapons.WeaponDetails[Game.WeaponSelect - 1].Magazin

func _ready():
	$Panel/Weapon/MagazinCapacity.text = "/" + str(MagazinSpace)
	$Panel/Weapon/Magazin.text = str(MagazinSpace)
	
	$Panel/Weapon/Weapon.texture = load("res://Assets/Weapons/" + Weapons.WeaponDetails[Game.WeaponSelect - 1].Name + "/Model.png")
	
	var Scale = Weapons.WeaponDetails[Game.WeaponSelect - 1].IconScale
	$Panel/Weapon/Weapon.scale = Vector2(Scale, Scale)
	
func shoot(Magazin):
	$Panel/Weapon/Magazin.text = str(Magazin)
	
func reload():
	$Panel/Weapon.hide()
	$Panel/Reload.show()
	$AnimationPlayer.play("reload")
	
func stopReload(Magazin):
	$AnimationPlayer.stop()
	$Panel/Reload.hide()
	$Panel/Weapon.show()
	
	Magazin = MagazinSpace
	$Panel/Weapon/Magazin.text = str(Magazin)
