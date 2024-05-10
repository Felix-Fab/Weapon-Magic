extends CharacterBody2D

const SPEED = 300.0

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * SPEED
	
	if(Input.is_action_pressed("ui_down")):
		print("Down Pressed")
		$AnimatedSprite2D.play("down")
		return
		
	if(Input.is_action_pressed("ui_up")):
		$AnimatedSprite2D.play("up")
		return
	
	if(Input.is_action_pressed("ui_right")):
		print("Right Pressed")
		$AnimatedSprite2D.play("right")
		return
		
	if(Input.is_action_pressed("ui_left")):
		$AnimatedSprite2D.play("left")
		return
	
	$AnimatedSprite2D.play("idle")

func _physics_process(delta):
	get_input()
	move_and_slide()
