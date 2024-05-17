extends Panel

var MagazinSpace = Weapons.WeaponDetails[Game.WeaponSelect - 1].Magazin

@onready var MagazinCapacity = $Weapon/MagazinCapacity
@onready var Magazin = $Weapon/Magazin
@onready var Reload = $Reload
@onready var WeaponIMG = $Weapon/WeaponIMG
@onready var WeaponNode = $Weapon
@onready var ReloadPlayer = $ReloadPlayer

func _ready():
	MagazinCapacity.text = "/" + str(MagazinSpace)
	Magazin.text = str(MagazinSpace)
	
	WeaponIMG.texture = load("res://Assets/Weapons/" + Weapons.WeaponDetails[Game.WeaponSelect - 1].Name + "/Model.png")
	
func shoot(Munition):
	Magazin.text = str(Munition)
	
func reload():
	WeaponNode.hide()
	Reload.show()
	ReloadPlayer.play("reload")
	
func stopReload(Munition):
	ReloadPlayer.stop()
	Reload.hide()
	WeaponNode.show()
	
	Magazin.text = str(Munition)
