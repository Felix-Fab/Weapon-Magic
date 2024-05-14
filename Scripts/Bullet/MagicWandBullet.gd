extends RigidBody2D

func _on_body_entered(body):
	if is_instance_of(body, TileMap):
		queue_free()
