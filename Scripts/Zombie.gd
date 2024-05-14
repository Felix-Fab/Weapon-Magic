extends CharacterBody2D

var movement_speed: float = 100.0
var accel = 4
@export var momenet_target: Node2D
@onready var navigation_agent = $Navigation/NavigationAgent2D
	
func _physics_process(delta):
	
	navigation_agent.target_position = momenet_target.global_position
	var direction = (navigation_agent.get_next_path_position() - global_position).normalized()
	
	navigation_agent.set_velocity(direction * movement_speed)
	
	if velocity.x > 0:
		$AnimatedSprite2D.play("Walk_Right")
		return
	else:
		$AnimatedSprite2D.play("Walk_Left")
		return

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()
