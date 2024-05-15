extends RigidBody2D

func _on_body_entered(body):
	
	print("Bullet:")
	print(body)
	
	if body.is_in_group("BulletWall"):
		queue_free()
