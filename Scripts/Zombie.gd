extends CharacterBody2D

var movement_speed: float = 500.0
@export var momenet_target: Node2D
@onready var navigation_agent = $Navigation/NavigationAgent2D


func _on_recalculate_timer_timeout():
	navigation_agent.target_position = momenet_target.position
	
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	
	var new_velocity: Vector2 = next_path_position - current_agent_position
	
	print(new_velocity)
	
	new_velocity = new_velocity.normalized()
	
	print(new_velocity)
	
	new_velocity = new_velocity * movement_speed
	
	velocity = new_velocity
	move_and_slide()


func _on_navigation_agent_2d_path_changed():
	print("Path changed")
