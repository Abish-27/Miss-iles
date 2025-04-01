extends Node2D

#class_name Main

var introPhase = true
var introCount = 0
var yapping = true
var totalCamps = 10
var tile : Vector2i
var atlas = Vector2i(0, 0)



var message_log_text: String = ""

var Dialogue = [">This is a console designed to help in your missions", 
">It displays information regarding missiles and survivor camps", 
">First look at the map\n>3 cities on this island have been taken over by zombies", 
">Phase 1: Survivor Camp Allocation\n>We must create camps for any survivors on the island", 
">The Green Button can be used to add camps\n>If you run out of camps quickly, you will lose",
">On each island you must place atleast 1 camp and are limited to max of 3", 
">Now place a camp on the highlighted areas",
">The closer you place a camp to a zombie city, the quicker your cure bar fills up",
">Once your bar is full, you have succesfully devised a cure and won the game",
">However remember that placing a camp too close can be dangerous",
">Phase 2: Zombie Extermination", 
">It seems our arsenal is limited to these old WW2 missiles we found in a bunker",
">This makes the blast radius and navigation systems of the missiles unpredictable",
">Try them out by clicking on the launch button",
">Missiles can be unpredictable so there is only one camp left!",
">Fortunately the camp's survival filled up our cure bar by a little",
">Now that you understand the missile system, I encourage you to save the other islands Chief",
">Fill up the cure bar before you run out of either missiles or survivor camps",
">Good luck...and don't miss!"]
var tracker = 0

var addingCamps = false
var campsAdded = 0
var saved = false

var missiling = false
var launching = false
var missiles = 5
var launchStage = 0
var missileFlying = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_message(">Welcome Chief!")
	add_message(">Click enter to continue...")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if yapping:
		if Input.is_action_just_pressed("next"):
			if tracker == Dialogue.size():
				get_tree().change_scene_to_file("res://home.tscn")
			elif tracker == 6:
				add_message(Dialogue[tracker])
				
				tile = Vector2i(1, 2)
				$Grid.set_cell(0, tile, 3, atlas)
				tile = Vector2i(4, 1)
				$Grid.set_cell(0, tile, 3, atlas)
				tile = Vector2i(7, 2)
				$Grid.set_cell(0, tile, 3, atlas)
				yapping = false
				addingCamps = true
				tracker += 1
			elif tracker == 14:
				print("correct tracker")
				yapping = false
				missiling = true
			else:
				add_message(Dialogue[tracker])
				tracker += 1
	elif addingCamps:
		if campsAdded == 3 and !saved:
			add_message(">Now click save")
			saved = true
			#addingCamps = false
		if Input.is_action_just_pressed("click"):
			tile = $Grid.local_to_map($Grid.to_local(get_global_mouse_position()))
			if tile == Vector2i(1, 2):
				$Grid.set_cell(0, tile, 1, atlas)
				campsAdded += 1
				totalCamps -= 1
				$AddCamp.text = "Save (Camps: " + str(totalCamps) + ")"
				add_message(">Survivor Camp at (1, 2)")
			elif tile == Vector2i(4, 1):
				$Grid.set_cell(0, tile, 1, atlas)
				campsAdded += 1
				totalCamps -= 1
				$AddCamp.text = "Save (Camps: " + str(totalCamps) + ")"
				add_message(">Survivor Camp at (4, 1)")
			elif tile == Vector2i(7, 2):
				$Grid.set_cell(0, tile, 1, atlas)
				campsAdded += 1
				totalCamps -= 1
				$AddCamp.text = "Save (Camps: " + str(totalCamps) + ")"
				add_message(">Survivor Camp at (7, 2)")
	if launching:
		if launchStage == 0:
			tile = Vector2i(4, 3)
			$Grid.set_cell(1, tile, 3, atlas)
			add_message(">Blow up the highlighted city")
			launchStage += 1
		elif launchStage == 1:
			if Input.is_action_just_pressed("click"):
				tile = $Grid.local_to_map($Grid.to_local(get_global_mouse_position()))
				if tile == Vector2i(4, 3):
					const MISSILE =  preload("res://missile.tscn")
					var new_missile = MISSILE.instantiate()
					var range = 1
					var coords = get_global_mouse_position()
					$MissileLauncher.look_at(coords)
					new_missile.target = coords
					new_missile.range = range
					new_missile.tile = tile
					new_missile.main = self
					new_missile.look_at(coords)
					new_missile.global_position = $MissileLauncher.global_position
					new_missile.global_rotation = $MissileLauncher.global_rotation
					add_child(new_missile)
					missileFlying = true
					launchStage += 1
					missiles -= 1
					$MissileButton.text = "Missiles: " + str(missiles)	
		elif launchStage == 2 and !missileFlying:
			add_message(">Excellent now this city")
			tile = Vector2i(2, 2)
			$Grid.set_cell(1, tile, 3, atlas)
			launchStage += 1
		elif launchStage == 3:
			if Input.is_action_just_pressed("click"):
				tile = $Grid.local_to_map($Grid.to_local(get_global_mouse_position()))
				if tile == Vector2i(2, 2):
					const MISSILE =  preload("res://missile.tscn")
					var new_missile = MISSILE.instantiate()
					var range = 2
					var coords = get_global_mouse_position()
					$MissileLauncher.look_at(coords)
					new_missile.target = coords
					new_missile.range = range
					new_missile.tile = tile
					new_missile.main = self
					new_missile.look_at(coords)
					new_missile.global_position = $MissileLauncher.global_position
					new_missile.global_rotation = $MissileLauncher.global_rotation
					add_child(new_missile)
					missileFlying = true
					launchStage += 1
					missiles -= 1
					$MissileButton.text = "Missiles: " + str(missiles)	
		elif launchStage == 4 and !missileFlying:
			add_message(">Oh no the missile's radius was x2, so our survivor camp was lost")
			tile = Vector2i(7, 4)
			$Grid.set_cell(1, tile, 3, atlas)
			launchStage += 1
		elif launchStage == 5:
			if Input.is_action_just_pressed("click"):
				tile = $Grid.local_to_map($Grid.to_local(get_global_mouse_position()))
				if tile == Vector2i(7, 4):
					tile = Vector2i(4, 1)
					const MISSILE =  preload("res://missile.tscn")
					var new_missile = MISSILE.instantiate()
					var range = 1
					var coords = $Grid.to_global($Grid.map_to_local(tile))
					$MissileLauncher.look_at(coords)
					new_missile.target = coords
					new_missile.range = range
					new_missile.tile = tile
					new_missile.main = self
					new_missile.look_at(coords)
					new_missile.global_position = $MissileLauncher.global_position
					new_missile.global_rotation = $MissileLauncher.global_rotation
					add_child(new_missile)
					missileFlying = true
					launchStage += 1
					missiles -= 1
					$MissileButton.text = "Missiles: " + str(missiles)	
		elif launchStage == 6 and !missileFlying:
			add_message(">The missile's navigation system was broken and it took out our camp!!")
			launchStage += 1
		elif launchStage == 7:
			if Input.is_action_just_pressed("click"):
				tile = $Grid.local_to_map($Grid.to_local(get_global_mouse_position()))
				if tile == Vector2i(7, 4):
					const MISSILE =  preload("res://missile.tscn")
					var new_missile = MISSILE.instantiate()
					var range = 2
					var coords = get_global_mouse_position()
					$MissileLauncher.look_at(coords)
					new_missile.target = coords
					new_missile.range = range
					new_missile.tile = tile
					new_missile.main = self
					new_missile.look_at(coords)
					new_missile.global_position = $MissileLauncher.global_position
					new_missile.global_rotation = $MissileLauncher.global_rotation
					add_child(new_missile)
					missileFlying = true
					launchStage += 1
					missiles -= 1
					$MissileButton.text = "Missiles: " + str(missiles)	
		elif launchStage == 8 and !missileFlying:
			add_message("Congratulations you took out all zombie camps!")
			launching = false
			yapping = true
			$ProgressBar.value = 8
			tracker += 1
			
			
			
					
			
			
			
			
			
				
		
			
		
	

func add_message(message: String):
	message_log_text += message + "\n"
	update_message_log()

func update_message_log():
	
	$RichTextLabel.text = message_log_text
	$RichTextLabel.call_deferred("minimum_size_changed")
	


func _on_add_camp_button_down():
	if addingCamps and campsAdded == 3:
		yapping = true
		


func _on_missile_button_pressed():
	print("button presed")
	if missiling:
		print("yes missling")
		missiling = false
		launching = true
		$MissileButton.text = "Missiles: " + str(missiles)	
		$MissileIcon.texture = preload("res://buttonPressed.png")

func blow_up(tile, r):
	#missileFlying = false
	$Explosion.play()
	$Grid.erase_cell(0, tile)
	$Grid.erase_cell(1, tile)
	var y = tile.x 
	var x = tile.y
	
	for num in range(1, r):
		tileCheck(x + num, y)
		tileCheck(x - num, y)
		tileCheck(x, y + num)
		tileCheck(x, y - num)
		
		tileCheck(x + 1, y + num)
		tileCheck(x + 1, y - num)
		tileCheck(x - 1, y + num)
		tileCheck(x - 1, y - num)

func tileCheck(x, y):	
	var tile = Vector2i(y, x)
	$Grid.erase_cell(0, tile)

