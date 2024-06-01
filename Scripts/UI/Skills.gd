extends Panel

@onready var Skill1 = $HBoxContainer/Skill1
@onready var Skill2 = $HBoxContainer/Skill2
@onready var Skill3 = $HBoxContainer/Skill3
@onready var Skill4 = $HBoxContainer/Skill4

func setProgressValue(Skill1_WaitTime, Skill2_WaitTime, Skill3_WaitTime, Skill4_WaitTime):
	Skill1.get_node("TextureProgressBar").max_value = Skill1_WaitTime
	Skill2.get_node("TextureProgressBar").max_value = Skill2_WaitTime
	Skill3.get_node("TextureProgressBar").max_value = Skill3_WaitTime
	Skill4.get_node("TextureProgressBar").max_value = Skill4_WaitTime
	
func setCooldownTime(Skill1_TimeLeft, Skill2_TimeLeft, Skill3_TimeLeft, Skill4_TimeLeft):
	
	if Skill1_TimeLeft != null:
		Skill1.get_node("Time").text = "%3.1f" % Skill1_TimeLeft
		Skill1.get_node("TextureProgressBar").value = Skill1_TimeLeft
		
	if Skill2_TimeLeft != null:
		Skill2.get_node("Time").text = "%3.1f" % Skill2_TimeLeft
		Skill2.get_node("TextureProgressBar").value = Skill2_TimeLeft
		
	if Skill3_TimeLeft != null:
		Skill3.get_node("Time").text = "%3.1f" % Skill3_TimeLeft
		Skill3.get_node("TextureProgressBar").value = Skill3_TimeLeft
		
	if Skill4_TimeLeft != null:
		Skill4.get_node("Time").text = "%3.1f" % Skill4_TimeLeft
		Skill4.get_node("TextureProgressBar").value = Skill4_TimeLeft
	
func setSkill1Cooldown():
	Skill1.disabled = true
	
func removeSkill1Cooldown():
	Skill1.disabled = false
	Skill1.get_node("Time").text = ""

func setSkill2Cooldown():
	Skill2.disabled = true
	
func removeSkill2Cooldown():
	Skill2.disabled = false
	Skill2.get_node("Time").text = ""
	
func setSkill3Cooldown():
	Skill3.disabled = true
	
func removeSkill3Cooldown():
	Skill3.disabled = false
	Skill3.get_node("Time").text = ""
	
func setSkill4Cooldown():
	Skill4.disabled = true
	
func removeSkill4Cooldown():
	Skill4.disabled = false
	Skill4.get_node("Time").text = ""
