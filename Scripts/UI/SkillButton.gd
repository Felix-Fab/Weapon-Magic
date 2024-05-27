extends TextureButton

@onready var progressBar = $TextureProgressBar
@onready var timer = $Timer
@onready var time = $Time

func _ready():
	progressBar.value = timer.wait_time
	set_process(false)
	
func _process(delta):
	time.text = "%3.1f" % timer.time_left
	progressBar.value = timer.time_left

func _on_pressed():
	timer.start()
	disabled = true
	set_process(true)

func _on_timer_timeout():
	disabled = false
	time.text = ""
	set_process(false)
