extends CharacterBody2D

const SPEED = 300.0

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * SPEED
	
	if(Input.is_action_pressed("ui_right")):
		$AnimatedSprite2D.play("right")
		
	if(Input.is_action_pressed("ui_left")):
		$AnimatedSprite2D.play("left")
		
	if(Input.is_action_pressed("ui_down")):
		$AnimatedSprite2D.play("down")
		
	if(Input.is_action_pressed("ui_up")):
		$AnimatedSprite2D.play("up")

func _physics_process(delta):
	get_input()
	move_and_slide()
