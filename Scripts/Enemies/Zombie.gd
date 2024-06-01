extends CharacterBody2D

var movement_speed: float = 100.0
var accel = 4
var health = 0

var Hitable = false

var PlayerBody: Node2D

@export var MovementTarget: Node2D
@onready var navigation_agent = $Navigation/NavigationAgent2D
@onready var HitCooldown = $HitCooldown

func _physics_process(_delta):
	
	navigation_agent.target_position = MovementTarget.global_position
	var direction = (navigation_agent.get_next_path_position() - global_position).normalized()
	
	navigation_agent.set_velocity(direction * movement_speed)
	
	if velocity.x > 0:
		$AnimatedSprite2D.set_flip_h(false)
	else:
		$AnimatedSprite2D.set_flip_h(true)
	
	if !$AnimatedSprite2D.is_playing():
		$AnimatedSprite2D.play("Walk")

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	
	move_and_slide()

func _on_bullet_detection_body_entered(body):
	
	if body.is_in_group("Bullet"):
		if body.has_meta("Damage") != true:
			return
		
		if(health == 0):
			$Healthbar.visible = true
		
		var Damage = body.get_meta("Damage")
		health += Damage
		
		if health >= self.get_meta("Health"):
			queue_free()
			body.queue_free()
			
			get_parent().enemyKilled("Zombie")
			
			get_node(body.get_meta("PlayerPath")).Kill(self.get_meta("Coins"))
		else:
			$Healthbar.value = health


func _on_hit_detection_body_entered(body):
	
	if body.is_in_group("Player"):
		body.Hit(self.get_meta("Damage"))
		
		$AnimatedSprite2D.play("Hit")
		
		PlayerBody = body
		
		Hitable = true
		HitCooldown.start()

func _on_hit_detection_body_exited(body):
	if body.is_in_group("Player"):
		Hitable = false
		HitCooldown.stop()


func _on_hit_cooldown_timeout():
	if Hitable:
		PlayerBody.Hit(self.get_meta("Damage"))
		$AnimatedSprite2D.play("Hit")
		
func skillHit(Damage, PlayerPath):
	if(health == 0):
		$Healthbar.visible = true
		
	health += Damage
		
	if health >= self.get_meta("Health"):
		queue_free()
			
		get_parent().enemyKilled("Zombie")
			
		get_node(PlayerPath).Kill(self.get_meta("Coins"))
	else:
		$Healthbar.value = health
