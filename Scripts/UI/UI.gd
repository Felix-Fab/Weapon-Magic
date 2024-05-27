extends CanvasLayer

@onready var HealthProgess = $Character/HP
@onready var ManaProgress = $Character/Mana
@onready var CoinsLabel = $Character/Coins
@onready var CharacterImage = $Character/CharacterImage
@onready var DamageEffekt = $DamageEffect
@onready var DamageEffektTimer = $DamageEffect/Timer
@onready var WaveMessage = $WaveMessage

func _ready():
	HealthProgess.value = 100
	ManaProgress.value = 100
	CoinsLabel.text = str(0)
	
	setCharacterBody()

func setCharacterBody():
	var t = AtlasTexture.new()

	# load a texture resource into the "AtlasTexture.atlas" field
	t.atlas = load('res://Assets/Characters/' + str(Game.PlayerSelect) + ".png")

	# set the region (customize this code accordingly to your assets)
	t.region = Rect2(7, 15, 33, 48)
	CharacterImage.texture = t

func setHealth(Health):
	HealthProgess.value = Health
	
func setMana(Mana):
	ManaProgress.value = Mana

func setCoins(Coins):
	CoinsLabel.text = str(Coins)

func showDamageEffect(Always):
	DamageEffekt.show()
	DamageEffekt.get_node("AnimationPlayer").play("Fade_In")
	DamageEffektTimer.start()

func _on_timer_timeout():
	DamageEffekt.get_node("AnimationPlayer").play("Fade_Out")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Fade_Out":
		DamageEffekt.hide()
		
func ShowWaveInfo(Message):
	WaveMessage.get_node("WaveInfo").text = Message
	WaveMessage.get_node("WaveInfo").show()
	
	WaveMessage.get_node("InfoTimer").start()
	
func SetPauseInfo(Message):
	WaveMessage.get_node("WaveCountdown").text = Message
	
func ShowPauseInfo():
	WaveMessage.get_node("WaveCountdown").show()
	
func HidePauseInfo():
	WaveMessage.get_node("WaveCountdown").hide()

func _on_info_timer_timeout():
	WaveMessage.get_node("WaveInfo").hide()
