extends CharacterBody2D

var bullet = preload("res://Szenes/Bullets/Ak47Bullet.tscn")

const SPEED = 150.00
const BulletSpeed = 1000
var Shootable = true

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * SPEED
	
	if(Input.is_action_pressed("ui_down")):
		$AnimatedSprite2D.play("Player" + str(Game.PlayerSelect) + "_Walk_Down")
		$AnimatedSprite2D2.play("default")
		return
		
	if(Input.is_action_pressed("ui_up")):
		$AnimatedSprite2D.play("Player" + str(Game.PlayerSelect) + "_Walk_Top")
		return
	
	if(Input.is_action_pressed("ui_right")):
		$AnimatedSprite2D.play("Player" + str(Game.PlayerSelect) + "_Walk_Right")
		return
		
	if(Input.is_action_pressed("ui_left")):
		$AnimatedSprite2D.play("Player" + str(Game.PlayerSelect) + "_Walk_Left")
		return
	
	$AnimatedSprite2D.play("Player" + str(Game.PlayerSelect) + "_Idle")

func _process(delta):
	if Input.is_action_pressed("ui_select") && Shootable:
		var bullet_instance = bullet.instantiate()
		
		bullet_instance.position = $Weapon_Down.global_position
		
		print($Weapon_Down.position)
		
		var InputVector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
		if InputVector.length() == 0:
			InputVector += Vector2(0, 1)
		
		var ImpulseVector = InputVector * BulletSpeed
	
		bullet_instance.get_node("Sprite2D").rotate(ImpulseVector.angle())
		bullet_instance.apply_impulse(ImpulseVector, Vector2())
		get_tree().get_root().add_child(bullet_instance)
		
		Shootable = false
		$Timer.start()

func _physics_process(delta):
	get_input()
	move_and_slide()


func _on_timer_timeout():
	Shootable = true
