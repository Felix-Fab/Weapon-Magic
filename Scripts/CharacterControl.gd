extends CharacterBody2D

var CurrentAnimation = "Idle"

var bullet = preload("res://Szenes/Bullets/MagicWandBullet.tscn")

const SPEED = 150.00

var Magazin = Weapons.WeaponDetails[Game.WeaponSelect - 1].Magazin
var Shootable = true
var WeaponReload = false
var CurrentRecoil = 0.0
var MaxRecoil = Weapons.WeaponDetails[Game.WeaponSelect - 1].MaxRecoil

func _ready():
	$WeaponCountdown.wait_time = Weapons.WeaponDetails[Game.WeaponSelect - 1].ShootTime
	$WeaponReload.wait_time = Weapons.WeaponDetails[Game.WeaponSelect - 1].ReloadTime
	
func _physics_process(delta):
	get_input()
	move_and_slide()

func _process(delta):
	if Input.is_action_pressed("weapon_fire") && Shootable && !WeaponReload:
		shoot()
		
	if Input.is_action_pressed("weapon_reload") && !WeaponReload:
		get_parent().get_node("WeaponMagazine").reload()
		
		$ReloadSound.play()
		
		WeaponReload = true
		
		$WeaponReload.start()

func _on_weapon_countdown_timeout():
	Shootable = true

func _on_weapon_reload_timeout():
	Magazin = Weapons.WeaponDetails[Game.WeaponSelect - 1].Magazin
	
	get_parent().get_node("WeaponMagazine").stopReload(Magazin)
	WeaponReload = false

func shoot():
	if Magazin > 0:
		var bullet_instance = bullet.instantiate()
			
		bullet_instance.position = $WeaponBulletPosition.get_node(str(Game.WeaponSelect) + "/" + CurrentAnimation).global_position
			
		var InputVector = Input.get_vector("A", "D", "W", "S")
			
		if InputVector.length() == 0:
			InputVector += Vector2(0, 1)
			
		var ImpulseVector = InputVector * Weapons.WeaponDetails[Game.WeaponSelect - 1].BulletSpeed
		
		# Calculate Recoil
		var recoil_degree_max = CurrentRecoil * 0.5
		var recoil_radians_actual = deg_to_rad(randf_range(-recoil_degree_max, recoil_degree_max))
		
		var recoil_increment = MaxRecoil * 0.1
		CurrentRecoil = clamp(CurrentRecoil + recoil_increment, 0.0, MaxRecoil)
		
		ImpulseVector = ImpulseVector.rotated(recoil_radians_actual)
		
		bullet_instance.get_node("Sprite2D").rotate(ImpulseVector.angle())
		bullet_instance.apply_impulse(ImpulseVector, Vector2())
		get_tree().get_root().add_child(bullet_instance)
		
		$ShootSound.play()
		
		Magazin -= 1
		
		get_parent().get_node("WeaponMagazine").shoot(Magazin)
		Shootable = false
		$WeaponCountdown.start()
	else:
		$EmptySound.play()

func get_input():
	var input_direction = Input.get_vector("A", "D", "W", "S")
	velocity = input_direction * SPEED
	
	if(Input.is_action_pressed("S")):
		$PlayerAnimation.play("Player" + str(Game.PlayerSelect) + "_Walk_Down")
		$WeaponAnimation.play("Weapon" + str(Game.WeaponSelect) + "_Walk_Down")
		
		CurrentAnimation = "Walk_Down"
		return
		
	if(Input.is_action_pressed("W")):
		$PlayerAnimation.play("Player" + str(Game.PlayerSelect) + "_Walk_Top")
		$WeaponAnimation.play("Weapon" + str(Game.WeaponSelect) + "_Walk_Top")
		
		CurrentAnimation = "Walk_Top"
		return
	
	if(Input.is_action_pressed("D")):
		$PlayerAnimation.play("Player" + str(Game.PlayerSelect) + "_Walk_Right")
		$WeaponAnimation.play("Weapon" + str(Game.WeaponSelect) + "_Walk_Right")
		
		CurrentAnimation = "Walk_Right"
		return
		
	if(Input.is_action_pressed("A")):
		$PlayerAnimation.play("Player" + str(Game.PlayerSelect) + "_Walk_Left")
		$WeaponAnimation.play("Weapon" + str(Game.WeaponSelect) + "_Walk_Left")
		
		CurrentAnimation = "Walk_Left"
		return
	
	$PlayerAnimation.play("Player" + str(Game.PlayerSelect) + "_Idle")
	$WeaponAnimation.play("Weapon" + str(Game.WeaponSelect) + "_Idle")
	
	CurrentAnimation = "Idle"
