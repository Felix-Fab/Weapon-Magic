extends Node

var fireball = preload("res://Szenes/Skills/Fire/Fireball.tscn")
var firelake = preload("res://Szenes/Skills/Fire/FireLake.tscn")

var PlayerSelect = 1
var WeaponSelect = 1
var SkillSelect = 1
var MapSelect = 1

var EnemyWaves = [
	{
		"NightBorne": 0,
		"Zombie": 1
	},
	{
		"NightBorne": 6,
		"Zombie": 6
	}
]

var Skillsets = [
	[
		{
			"Name": "Fireball",
			"Action": Callable(self, "shootFireball"),
			"Cooldown": 2,
			"Damage": 50
		},
		{
			"Name": "FireLake",
			"Action": Callable(self, "shootFireLake"),
			"Cooldown": 5,
			"Damage": 20
		},
		{
			"Name": "Fireball",
			"Action": Callable(self, "shootFireball"),
			"Cooldown": 2,
			"Damage": 50
		},
		{
			"Name": "Fireball",
			"Action": Callable(self, "shootFireball"),
			"Cooldown": 2,
			"Damage": 50
		}
	],
	[
		{
			"Name": "Fireball",
			"Action": Callable(self, "shootFireball"),
			"Cooldown": 2,
			"Damage": 50
		},
		{
			"Name": "Fireball",
			"Action": Callable(self, "shootFireball"),
			"Cooldown": 2,
			"Damage": 50
		},
		{
			"Name": "Fireball",
			"Action": Callable(self, "shootFireball"),
			"Cooldown": 2,
			"Damage": 50
		},
		{
			"Name": "Fireball",
			"Action": Callable(self, "shootFireball"),
			"Cooldown": 2,
			"Damage": 50
		}
	],
	[
		{
			"Name": "Fireball",
			"Action": Callable(self, "shootFireball"),
			"Cooldown": 2,
			"Damage": 50
		},
		{
			"Name": "Fireball",
			"Action": Callable(self, "shootFireball"),
			"Cooldown": 2,
			"Damage": 50
		},
		{
			"Name": "Fireball",
			"Action": Callable(self, "shootFireball"),
			"Cooldown": 2,
			"Damage": 50
		},
		{
			"Name": "Fireball",
			"Action": Callable(self, "shootFireball"),
			"Cooldown": 2,
			"Damage": 50
		}
	],
	[
		{
			"Name": "Fireball",
			"Action": Callable(self, "shootFireball"),
			"Cooldown": 2,
			"Damage": 50
		},
		{
			"Name": "Fireball",
			"Action": Callable(self, "shootFireball"),
			"Cooldown": 2,
			"Damage": 50
		},
		{
			"Name": "Fireball",
			"Action": Callable(self, "shootFireball"),
			"Cooldown": 2,
			"Damage": 50
		},
		{
			"Name": "Fireball",
			"Action": Callable(self, "shootFireball"),
			"Cooldown": 2,
			"Damage": 50
		}
	]
]

func shootFireball(Damage, playerPosition, mousePosition, Character):
	
	var fireball_instance = fireball.instantiate()
	
	fireball_instance.global_position = playerPosition
	
	var ImpulseVector = (mousePosition - playerPosition).normalized() * 400
	
	fireball_instance.rotate(ImpulseVector.angle())
	fireball_instance.apply_impulse(ImpulseVector, Vector2())
	
	fireball_instance.set_meta("PlayerPath", Character.get_path())
	fireball_instance.set_meta("Damage", Damage)
	
	get_tree().get_root().add_child(fireball_instance)
	
func shootFireLake(Damage, playerPosition, mousePosition, Character):
	
	var firelake_instance = firelake.instantiate()
	firelake_instance.global_position = mousePosition
	
	firelake_instance.set_meta("PlayerPath", Character.get_path())
	firelake_instance.set_meta("Damage", Damage)
	
	get_tree().get_root().add_child(firelake_instance)
