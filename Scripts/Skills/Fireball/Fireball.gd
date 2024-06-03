extends RigidBody2D

@onready var DefaultAnimation =  $AnimatedSprite2D
@onready var ExplodeAnimation = $ExplodeAnimation
@onready var CollisionShape = $CollisionShape2D
@onready var ExplodeSound = $ExplodeSound

var HitList = []

func _ready():
	DefaultAnimation.play("default")

func _on_body_entered(body):
	if body.is_in_group("BulletWall"):
		playExplodeAnimation()
		hitAllEnemies()

func _on_hit_detection_body_entered(body):
	if body.is_in_group("Enemy"):
		HitList.append(body)

func _on_hit_detection_body_exited(body):
	for i in range(HitList.size() - 1):
		if is_instance_valid(HitList[i]):
			if HitList[i].get_instance_id() == body.get_instance_id():
				HitList.remove_at(i)

func hitAllEnemies():
	for i in HitList:
		if is_instance_valid(i):
			i.skillHit(get_meta("Damage"), self.get_meta("PlayerPath"))
		
func playExplodeAnimation():
	
	set_deferred("freeze", true)
	
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	
	DefaultAnimation.visible = false
	ExplodeAnimation.visible = true
	ExplodeAnimation.play("default")
	ExplodeSound.play()

func _on_explode_sound_finished():
	queue_free()
