extends CharacterBody2D

var Health = 100
var Mana = 100
var Coins = 0

var WeaponDetails = Weapons.WeaponDetails[Game.WeaponSelect - 1]
var SelectedSkills = Game.Skillsets[Game.SkillSelect - 1]

var CurrentAnimation = "Idle"

var bullet = preload("res://Szenes/Bullet/DefaultBullet.tscn")

const SPEED = 150.00

var Magazin = WeaponDetails.Magazin
var Shootable = true
var WeaponReload = false
var CurrentRecoil = 0.0
var MaxRecoil = WeaponDetails.MaxRecoil

var Skill1_Timout = false
var Skill2_Timout = false
var Skill3_Timout = false
var Skill4_Timout = false
var Skill5_Timout = false

@export var Skill1_Key:String
@export var Skill2_Key:String
@export var Skill3_Key:String
@export var Skill4_Key:String

@onready var Skill1_Timer = $Skills/Skill1_Timer
@onready var Skill2_Timer = $Skills/Skill2_Timer
@onready var Skill3_Timer = $Skills/Skill3_Timer
@onready var Skill4_Timer = $Skills/Skill4_Timer

@onready var WeaponCountdown = $WeaponCountdown
@onready var WeaponReloadControl = $WeaponReload
@onready var ShootSound = $ShootSound
@onready var ReloadSound = $ReloadSound
@onready var EmptySound = $EmptySound
@onready var SkillColldownSound = $SkillCooldown
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
	
	Camera.set_limit(SIDE_LEFT, tilemap_rect.position.x * tilemap_cell_size.x * Tilemap.scale.x)
	Camera.set_limit(SIDE_RIGHT, tilemap_rect.end.x * tilemap_cell_size.x * Tilemap.scale.x)
	Camera.set_limit(SIDE_TOP, tilemap_rect.position.y * tilemap_cell_size.y * Tilemap.scale.y)
	Camera.set_limit(SIDE_BOTTOM, tilemap_rect.end.y * tilemap_cell_size.y * Tilemap.scale.y)
	
	setSkillSetup()
	UI.Skills.setProgressValue(Skill1_Timer.wait_time, Skill2_Timer.wait_time, Skill3_Timer.wait_time, Skill4_Timer.wait_time)
	
func _physics_process(_delta):
	get_input()
	move_and_slide()

func _process(_delta):
	
	var Skill1Cooldown = null
	var Skill2Cooldown = null
	var Skill3Cooldown = null
	var Skill4Cooldown = null
	
	if Skill1_Timout:
		Skill1Cooldown = Skill1_Timer.time_left
		
	if Skill2_Timout:
		Skill2Cooldown = Skill2_Timer.time_left
		
	if Skill3_Timout:
		Skill3Cooldown = Skill3_Timer.time_left
		
	if Skill4_Timout:
		Skill4Cooldown = Skill4_Timer.time_left
	
	UI.Skills.setCooldownTime(Skill1Cooldown, Skill2Cooldown, Skill3Cooldown, Skill4Cooldown)
	
	if Input.is_action_pressed("weapon_fire") && Shootable && !WeaponReload:
		shoot()
		
	if Input.is_action_pressed("weapon_reload") && !WeaponReload:
		UI.get_node('Weapon').reload()
		ReloadSound.play()

		WeaponReload = true
		
		WeaponReloadControl.start()
		
	if Input.is_action_just_pressed(Skill1_Key):
		ShootSkill(1)
		
	if Input.is_action_just_pressed(Skill2_Key):
		ShootSkill(2)
		
	if Input.is_action_just_pressed(Skill3_Key):
		ShootSkill(3)
		
	if Input.is_action_just_pressed(Skill4_Key):
		ShootSkill(4)

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

func ShootSkill(SkillNumber):
	var Timeout = getSkillTimeout(SkillNumber)
	
	var Damage = SelectedSkills[SkillNumber - 1]["Damage"]
	
	if !Timeout:
		SelectedSkills[SkillNumber - 1]["Action"].call(Damage ,global_position, get_global_mouse_position(), self)
		setSkillTimeout(SkillNumber)
	else:
		SkillColldownSound.play()
	
func getSkillTimeout(SkillNumber):
	match SkillNumber:
		1: return Skill1_Timout
		2: return Skill2_Timout
		3: return Skill3_Timout
		4: return Skill4_Timout
		5: return Skill4_Timout
		
func setSkillTimeout(SkillNumber):
	match SkillNumber:
		1: 
			Skill1_Timout = true
			Skill1_Timer.start()
			UI.Skills.setSkill1Cooldown()
		2: 
			Skill2_Timout = true
			Skill2_Timer.start()
			UI.Skills.setSkill2Cooldown()
		3: 
			Skill3_Timout = true
			Skill3_Timer.start()
			UI.Skills.setSkill3Cooldown()
		4: 
			Skill4_Timout = true
			Skill4_Timer.start()
			UI.Skills.setSkill4Cooldown()

func _on_skill_1_timer_timeout():
	Skill1_Timout = false
	UI.Skills.removeSkill1Cooldown()

func _on_skill_2_timer_timeout():
	Skill2_Timout = false
	UI.Skills.removeSkill2Cooldown()

func _on_skill_3_timer_timeout():
	Skill3_Timout = false
	UI.Skills.removeSkill3Cooldown()

func _on_skill_4_timer_timeout():
	Skill4_Timout = false
	UI.Skills.removeSkill4Cooldown()

func setSkillSetup():
	Skill1_Timer.wait_time = SelectedSkills[0]["Cooldown"]
	Skill2_Timer.wait_time = SelectedSkills[1]["Cooldown"]
	Skill3_Timer.wait_time = SelectedSkills[2]["Cooldown"]
	Skill4_Timer.wait_time = SelectedSkills[3]["Cooldown"]
