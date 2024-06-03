extends RigidBody2D

@onready var DefaultAnimation = $AnimatedSprite2D
@onready var HitTimer = $HitTimer

var HitList = []

func _ready():
	DefaultAnimation.play("default")
	HitTimer.start()

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("Enemy"):
		print("Enemy detected: " + str(body))
		HitList.append(body)

func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	for i in range(HitList.size() - 1):
		if is_instance_valid(HitList[i]):
			if HitList[i].get_instance_id() == body.get_instance_id():
				print("Remove Enemy")
				HitList.remove_at(i)

func _on_hit_timer_timeout():
	print(HitList)
	for i in range(HitList.size() - 1):
		if is_instance_valid(HitList[i]):
			print("Set Damage: " + str(get_meta("Damage")))
			HitList[i].skillHit(get_meta("Damage"), self.get_meta("PlayerPath"))
