extends TextureButton

@export var shortcutKey: String
@export var shortcutName: String

@onready var progressBar = $TextureProgressBar
@onready var timer = $Timer
@onready var time = $Time
@onready var shortcutUI = $Shortcut

var Cooldown = false

func _ready():
	shortcutUI.text = shortcutName
	progressBar.max_value = timer.wait_time
	
func _process(delta):
	
	if Input.is_action_just_pressed(shortcutKey) && !Cooldown:
		timer.start()
		disabled = true
		Cooldown = true
		
	if Cooldown:
		time.text = "%3.1f" % timer.time_left
		progressBar.value = timer.time_left

func _on_timer_timeout():
	disabled = false
	time.text = ""
	Cooldown = false

func shoot():
	disabled = true
	Cooldown = true
