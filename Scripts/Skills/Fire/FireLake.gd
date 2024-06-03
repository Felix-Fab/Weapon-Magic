extends Area2D

@onready var DefaultAnimation = $AnimatedSprite2D
@onready var HitTimer = $HitTimer

var HitList = []

func _ready():
	DefaultAnimation.play("default")

func _on_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if body.is_in_group("Enemy"):
		HitList.append(body)

func _on_body_shape_exited(_body_rid, body, _body_shape_index, _local_shape_index):
	if body != null:
		for i in range(HitList.size()):
			if is_instance_valid(HitList[i]):
				if HitList[i].get_instance_id() == body.get_instance_id():
					HitList.remove_at(i)
					return

func _on_hit_timer_timeout():
	for i in range(HitList.size()):
		if is_instance_valid(HitList[i]):
			HitList[i].skillHit(get_meta("Damage"), self.get_meta("PlayerPath"))

func _on_despawn_timer_timeout():
	queue_free()
