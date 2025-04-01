extends Node2D

var intro = true
var Dialogue = ["Year: 1989 
(click enter to continue...)", "A research facility in California announces a genetic modifier which they claimed could enhance human capabilities", 
"This was not the case.....", 
"The drug transformed its users into mutants with pure animal instincs, zombies",
 "Spreading like a virus, the drug caused a global pandemic leading to the dowfall of several important governments and institutions", 
"Year: 1991", "Location: The Pacific Island Region", "As the chief commander in charge of the Pacific, it is your responsiblity to liberate the varios islands in the region that have fallen to this deathly virus",
"All you have are some malfunctioning WW2 missiles, and your incomparable wits (hopefully)", "Good luck...", "And Don't Miss!"]

var typing = false
var introCount = 0
var current_char = 0
var messageList = []



func _ready():
	typing = true
	current_char = 0
	messageList = Dialogue[introCount].split("")
	$charTime.start()
	introCount += 1
	$TypingSound.play()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !typing:
		if Input.is_action_just_pressed("next"):
			if introCount == Dialogue.size():
				$charTime.stop()
				get_tree().change_scene_to_file("res://home.tscn")
			else:
				$IntroText.text = ""
				typing = true
				current_char = 0
				messageList = Dialogue[introCount].split("")
				$charTime.start()
				introCount += 1
				$TypingSound.play()
	


func _on_char_time_timeout():
	if current_char == messageList.size():
		typing = false
		$charTime.stop()
		$TypingSound.stop()
	else:
		$IntroText.text += messageList[current_char]
		current_char += 1
