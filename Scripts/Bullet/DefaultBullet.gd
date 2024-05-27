extends RigidBody2D

var WeaponSelect = Game.WeaponSelect - 1
var WeaponDetails = Weapons.WeaponDetails[WeaponSelect]
@onready var Sprite = $Sprite2D

func _ready():
	self.set_meta("Damage", WeaponDetails.Damage)
	
	Sprite.texture = load('res://Assets/Weapons/Bullet/' + WeaponDetails.Name + 'Bullet.png')

func _on_body_entered(body):
	print("Hitted")
	print("Body")
	if body.is_in_group("BulletWall"):
		queue_free()
