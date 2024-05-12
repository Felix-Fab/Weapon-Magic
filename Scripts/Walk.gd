extends CharacterBody2D

var CurrentAnimation = "Idle"

var bullet = preload("res://Szenes/Bullets/Ak47Bullet.tscn")

const SPEED = 150.00
const BulletSpeed = 1000
var Shootable = true

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * SPEED
	
	if(Input.is_action_pressed("ui_down")):
		$PlayerAnimation.play("Player" + str(Game.PlayerSelect) + "_Walk_Down")
		$WeaponAnimation.play("Weapon" + str(Game.WeaponSelect) + "_Walk_Down")
		
		CurrentAnimation = "Walk_Down"
		return
		
	if(Input.is_action_pressed("ui_up")):
		$PlayerAnimation.play("Player" + str(Game.PlayerSelect) + "_Walk_Top")
		$WeaponAnimation.play("Weapon" + str(Game.WeaponSelect) + "_Walk_Top")
		
		CurrentAnimation = "Walk_Top"
		return
	
	if(Input.is_action_pressed("ui_right")):
		$PlayerAnimation.play("Player" + str(Game.PlayerSelect) + "_Walk_Right")
		$WeaponAnimation.play("Weapon" + str(Game.WeaponSelect) + "_Walk_Right")
		
		CurrentAnimation = "Walk_Right"
		return
		
	if(Input.is_action_pressed("ui_left")):
		$PlayerAnimation.play("Player" + str(Game.PlayerSelect) + "_Walk_Left")
		$WeaponAnimation.play("Weapon" + str(Game.WeaponSelect) + "_Walk_Left")
		
		CurrentAnimation = "Walk_Left"
		return
	
	$PlayerAnimation.play("Player" + str(Game.PlayerSelect) + "_Idle")
	$WeaponAnimation.play("Weapon" + str(Game.WeaponSelect) + "_Idle")
	
	CurrentAnimation = "Idle"
	
func _physics_process(delta):
	get_input()
	move_and_slide()

func _process(delta):
	if Input.is_action_pressed("ui_select") && Shootable:
		var bullet_instance = bullet.instantiate()
		
		bullet_instance.position = $WeaponBulletPosition.get_node(str(Game.WeaponSelect) + "/" + CurrentAnimation).global_position
		
		var InputVector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
		if InputVector.length() == 0:
			InputVector += Vector2(0, 1)
		
		var ImpulseVector = InputVector * BulletSpeed
	
		bullet_instance.get_node("Sprite2D").rotate(ImpulseVector.angle())
		bullet_instance.apply_impulse(ImpulseVector, Vector2())
		get_tree().get_root().add_child(bullet_instance)
		
		Shootable = false
		$WeaponCountdown.start()

func _on_weapon_countdown_timeout():
	Shootable = true
