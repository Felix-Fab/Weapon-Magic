extends CharacterBody2D

var Health = 100
var Mana = 100
var Coins = 0

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
@export var UI: CanvasLayer

@onready var PlayerAnimation = $PlayerAnimation
@onready var WeaponAnimation = $WeaponAnimation

@onready var Tilemap = get_parent().get_node("TileMap")
@onready var Camera = $Camera2D

func _ready():
	PlayerAnimation.play("Player" + str(Game.PlayerSelect) + "_" + CurrentAnimation)
	WeaponAnimation.play("Weapon" + str(Game.WeaponSelect) + "_" + CurrentAnimation)
	
	WeaponCountdown.wait_time = WeaponDetails.ShootTime
	WeaponReloadControl.wait_time = WeaponDetails.ReloadTime
	
	ShootSound.stream = load('res://Sounds/Weapons/' + WeaponDetails.Name + "/" + WeaponDetails.Name + "Shoot.wav")
	ReloadSound.stream = load('res://Sounds/Weapons/' + WeaponDetails.Name + "/" + WeaponDetails.Name + "Reload.wav")
	EmptySound.stream = load('res://Sounds/Weapons/' + WeaponDetails.Name + "/" + WeaponDetails.Name + "Empty.wav")
	
	var tilemap_rect = Tilemap.get_used_rect()
	var tilemap_cell_size = Tilemap.tile_set.tile_size
	
	print(tilemap_rect)
	print(tilemap_rect.position.y * tilemap_cell_size.y * Tilemap.scale.y)
	
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
		UI.get_node('Weapon').reload()
		
		
		ReloadSound.play()
		
		WeaponReload = true
		
		WeaponReloadControl.start()

func _on_weapon_countdown_timeout():
	Shootable = true

func _on_weapon_reload_timeout():
	Magazin = Weapons.WeaponDetails[Game.WeaponSelect - 1].Magazin
	
	UI.get_node('Weapon').stopReload(Magazin)
	WeaponReload = false

func shoot():
	if Magazin > 0:
		var bullet_instance = bullet.instantiate()
		
		bullet_instance.position = $WeaponBulletPosition.get_node(str(Game.WeaponSelect) + "/" + CurrentAnimation).global_position
			
		var InputVector = Input.get_vector("A", "D", "W", "S")
			
		if InputVector.length() == 0:
			var BulletVector = Vector2(0,1)
			if CurrentAnimation == "Walk_Top":
				BulletVector = Vector2(0, -1)
			elif  CurrentAnimation == "Walk_Right":
				BulletVector = Vector2(1, 0)
			elif  CurrentAnimation == "Walk_Left":
				BulletVector = Vector2(-1, 0)
			
			InputVector = BulletVector
		
		var ImpulseVector = InputVector * WeaponDetails.BulletSpeed
		
		# Calculate Recoil
		var recoil_degree_max = CurrentRecoil * 0.5
		var recoil_radians_actual = deg_to_rad(randf_range(-recoil_degree_max, recoil_degree_max))
		
		var recoil_increment = MaxRecoil * 0.1
		CurrentRecoil = clamp(CurrentRecoil + recoil_increment, 0.0, MaxRecoil)
		
		ImpulseVector = ImpulseVector.rotated(recoil_radians_actual)
		
		bullet_instance.rotate(ImpulseVector.angle())
		bullet_instance.apply_impulse(ImpulseVector, Vector2())
		
		bullet_instance.set_meta("PlayerPath", self.get_path())
		
		get_tree().get_root().add_child(bullet_instance)
		
		ShootSound.play()
		
		Magazin -= 1
		UI.get_node('Weapon').shoot(Magazin)
		
		Shootable = false
		WeaponCountdown.start()
	else:
		EmptySound.play()

func get_input():
	var input_direction = Input.get_vector("A", "D", "W", "S")
	velocity = input_direction * SPEED
	
	if velocity.length() == 0:
		PlayerAnimation.stop()
		WeaponAnimation.stop()
	else:
		var direction = "Down"
		if velocity.x < 0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Top"
		
		PlayerAnimation.play("Player" + str(Game.PlayerSelect) + "_Walk_" + direction)
		WeaponAnimation.play("Weapon" + str(Game.WeaponSelect) + "_Walk_" + direction)
		
		CurrentAnimation = "Walk_" + direction
		
func Hit(Damage):
	Health -= Damage
	
	if(Health <= 0):
		get_tree().change_scene_to_file("res://Szenes/Pages/CharacterSelection.tscn")
	
	UI.setHealth(Health)
	UI.showDamageEffect(false)
	
func Kill(NewCoins):
	Coins += NewCoins
	UI.setCoins(Coins)
