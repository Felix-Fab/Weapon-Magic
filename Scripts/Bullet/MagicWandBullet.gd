extends RigidBody2D

func _ready():
	$Sprite2D.play("shoot_begin")

func _on_body_entered(body):
	if is_instance_of(body, TileMap):
		$Sprite2D.play("shoot_destroy")
		$ShootDestroyTimer.start()

func _on_timer_timeout():
	$Sprite2D.play("shoot_normal")
	
func _on_shoot_destroy_timer_timeout():
	queue_free()
