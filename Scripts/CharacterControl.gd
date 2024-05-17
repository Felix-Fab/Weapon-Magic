extends CharacterBody2D

var WeaponDetails = Weapons.WeaponDetails[Game.WeaponSelect - 1]

var CurrentAnimation = "Idle"

var bullet = preload("res://Szenes/Bullet/DefaultBullet.tscn")

const SPEED = 150.00

var Magazin = WeaponDetails.Magazin
var Shootable = true
var WeaponReload = false
var CurrentRecoil = 0.0
var MaxRecoil = WeaponDetails.MaxRecoil

@onready var WeaponCountdown = $WeaponCountdown
@onready var WeaponReloadControl = $WeaponReload
@onready var ShootSound = $ShootSound
@onready var ReloadSound = $ReloadSound
@onready var EmptySound = $EmptySound
@onready var WeaponMagazine = get_parent().get_node("Ui/Panel")

@onready var Tilemap = get_parent().get_node("TileMap")
@onready var Camera = $Camera2D

func _ready():
	WeaponCountdown.wait_time = WeaponDetails.ShootTime
	WeaponReloadControl.wait_time = WeaponDetails.ReloadTime
	
	ShootSound.stream = load('res://Sounds/Weapons/' + WeaponDetails.Name + "/" + WeaponDetails.Name + "Shoot.wav")
	ReloadSound.stream = load('res://Sounds/Weapons/' + WeaponDetails.Name + "/" + WeaponDetails.Name + "Reload.wav")
	EmptySound.stream = load('res://Sounds/Weapons/' + WeaponDetails.Name + "/" + WeaponDetails.Name + "Empty.wav")
	
	var tilemap_rect = Tilemap.get_used_rect()
	var tilemap_cell_size = Tilemap.tile_set.tile_size
	
	Camera.set_limit(SIDE_LEFT, tilemap_rect.position.x * tilemap_cell_size.x * Tilemap.scale.x)
	Camera.set_limit(SIDE_RIGHT, tilemap_rect.end.x * tilemap_cell_size.x * Tilemap.scale.x)
	Camera.set_limit(SIDE_TOP, tilemap_rect.position.y * tilemap_cell_size.y * Tilemap.scale.y)
	Camera.set_limit(SIDE_BOTTOM, tilemap_rect.end.y * tilemap_cell_size.y * Tilemap.scale.y)
	
func _physics_process(delta):
	get_input()
	move_and_slide()

func _process(delta):
	if Input.is_action_pressed("weapon_fire") && Shootable && !WeaponReload:
		shoot()
		
	if Input.is_action_pressed("weapon_reload") && !WeaponReload:
		WeaponMagazine.reload()
		
		ReloadSound.play()
		
		WeaponReload = true
		
		WeaponReloadControl.start()

func _on_weapon_countdown_timeout():
	Shootable = true

func _on_weapon_reload_timeout():
	Magazin = Weapons.WeaponDetails[Game.WeaponSelect - 1].Magazin
	
	WeaponMagazine.stopReload(Magazin)
	WeaponReload = false

func shoot():
	if Magazin > 0:
		var bullet_instance = bullet.instantiate()
			
		bullet_instance.position = $WeaponBulletPosition.get_node(str(Game.WeaponSelect) + "/" + CurrentAnimation).global_position
			
		var InputVector = Input.get_vector("A", "D", "W", "S")
			
		if InputVector.length() == 0:
			InputVector += Vector2(0, 1)
			
		var ImpulseVector = InputVector * WeaponDetails.BulletSpeed
		
		# Calculate Recoil
		var recoil_degree_max = CurrentRecoil * 0.5
		var recoil_radians_actual = deg_to_rad(randf_range(-recoil_degree_max, recoil_degree_max))
		
		var recoil_increment = MaxRecoil * 0.1
		CurrentRecoil = clamp(CurrentRecoil + recoil_increment, 0.0, MaxRecoil)
		
		ImpulseVector = ImpulseVector.rotated(recoil_radians_actual)
		
		bullet_instance.get_node("Sprite2D").rotate(ImpulseVector.angle())
		bullet_instance.apply_impulse(ImpulseVector, Vector2())
		get_tree().get_root().add_child(bullet_instance)
		
		ShootSound.play()
		
		Magazin -= 1
		
		WeaponMagazine.shoot(Magazin)
		Shootable = false
		WeaponCountdown.start()
	else:
		EmptySound.play()

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
