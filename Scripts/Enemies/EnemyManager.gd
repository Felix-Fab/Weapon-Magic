extends Node2D

@export var PlayerCharacter: CharacterBody2D
@export var SpawnPositions:Array
@export var UI: CanvasLayer

@onready var WavePauseTimer = $WavePause

var EnemyWaves = Game.EnemyWaves
var CurrentWave = EnemyWaves[0]
var CurrentWaveIndex = 0
var MaxWaveIndex = EnemyWaves.size() - 1
var WavePause = false

func _ready():
	spawnWave()

func _process(_delta):
	UI.SetPauseInfo("Nächste Wave in %02d:%02d Sek." % WavePauseTimeLeft())

func spawnWave():
	
	UI.ShowWaveInfo("Wave " + str(CurrentWaveIndex + 1) + " beginnt!")
	
	var WaveEnemies = CurrentWave.keys()
	
	for x in WaveEnemies:
		var EnemySzene = load("res://Szenes/Enemies/" + x + ".tscn")
		
		for y in CurrentWave[x]:
			var EnemyInstance = EnemySzene.instantiate()
			EnemyInstance.global_position = SpawnPositions[randf_range(0, SpawnPositions.size())]
			EnemyInstance.MovementTarget = PlayerCharacter
			
			add_child(EnemyInstance)
		
func enemyKilled(Enemy):
	CurrentWave[Enemy] -= 1
	
	if checkWaveCleared():
		if !checkAllWavesFinished():
			startWavePause()
	
func checkWaveCleared():
	var WaveEnemies = CurrentWave.keys()
	
	for x in WaveEnemies:
		if CurrentWave[x] > 0:
			return false
			
	return true

func checkAllWavesFinished():
	if CurrentWaveIndex == MaxWaveIndex:
		UI.ShowWaveInfo("Gewonnen :D")
		return true
		
	return false

func goToNextWave():
	
	CurrentWaveIndex += 1
	
	CurrentWave = EnemyWaves[CurrentWaveIndex]
	
	spawnWave()
	
func startWavePause():
	UI.ShowPauseInfo()
	WavePauseTimer.start()
	
func WavePauseTimeLeft():
	var time_left = WavePauseTimer.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return [minute, second]

func _on_wave_pause_timeout():
	goToNextWave()
	UI.HidePauseInfo()
