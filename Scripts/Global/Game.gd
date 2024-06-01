extends Node

var fireball = preload("res://Szenes/Skills/Fire/Fireball.tscn")

var PlayerSelect = 1
var WeaponSelect = 1
var SkillSelect = 1
var MapSelect = 1

var EnemyWaves = [
	{
		"NightBorne": 0,
		"Zombie": 10
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
	
