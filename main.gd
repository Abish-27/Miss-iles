extends Node2D


class_name Main

var map = []
var cure = []
var mult = []
var addingCamps = false
var campCount = 0
var launching = false
var missiles = 6
var Cure = 0
var CampsFin = false
var printed_positions = {}
var TurnFin = false
var turn_count = 0  # Counter for the turns
var rangeList = [1, 1, 1, 2, 2, 2, 3, 3, 4]  # Adjusted to reduce high range values
var missileFlying = false
# Message log related
var message_log_text: String = ""
var totalCamps = 10
var dying = false



#-1 - next to zombie
#0- empty
#1- zombie
#2- survivor

# Called when the node enters the scene tree for the first time.
func _ready():
	turn_count = 0  # Initialize the turn counter
	for i in range(7):
		map.append([])
		for j in range(10):
			map[i].append(0)
	print(map)
	
	createZombieCamps(3)
	
	# Initialize the message log
	message_log_text = "Welcome Chief!\n"
	update_message_log()
	#add_message("Welcome Chief")
	$Console.play("default")

func _process(delta):
	if addingCamps:
		if Input.is_action_just_pressed("click"):
			var tile : Vector2i = $Grid.local_to_map($Grid.to_local(get_global_mouse_position()))
			
			if campCount < 3 and tile.x > -1 and tile.x < 10 and tile.y > -1 and tile.y < 7:
				if map[tile.y][tile.x] == 0 or map[tile.y][tile.x] == -1:
					var atlas = Vector2i(0, 0)
					$Grid.set_cell(0, tile, 3, atlas)
					map[tile.y][tile.x] = 2
					campCount += 1
					add_message("Survivor camp added at (%d, %d)." % [tile.x, tile.y])
					totalCamps -= 1
					$AddCamp.text = "Save (Camps: " + str(totalCamps) + ")"
					
		elif Input.is_action_just_pressed("right_click"):
			var tile : Vector2i = $Grid.local_to_map($Grid.to_local(get_global_mouse_position()))
			if campCount > 0 and tile.x > -1 and tile.x < 10 and tile.y > -1 and tile.y < 7:
				if map[tile.y][tile.x] == 2:
					$Grid.erase_cell(0, tile)
					map[tile.y][tile.x] = 0
					campCount -= 1
					add_message("Survivor camp removed from (%d, %d)." % [tile.x, tile.y])
					totalCamps += 1
					$AddCamp.text = "Save (Camps: " + str(totalCamps) + ")"
					
	elif launching and !missileFlying:
		if Input.is_action_just_pressed("click") and missiles > 0:
			var tile : Vector2i = $Grid.local_to_map($Grid.to_local(get_global_mouse_position()))
			# Check if it's in tilemap
			if tile.x > -1 and tile.x < 10 and tile.y > -1 and tile.y < 7:
				

				#30% navigation system is broken
				var nav = randf()
				var range = rangeList.pick_random()
				missileFlying = true
				if nav < 0.3:
					var row = randi_range(0, 6)
					var col = randi_range(0, 9)
					tile = Vector2i(col, row)
					print("broken nav")
					print(tile)
					launch_missile($Grid.to_global($Grid.map_to_local(tile)), tile, range)
					add_message("NAV SYSTEM MALFUNCTIONED!")
					#add_message("NAV SYSTEM MALFUNCTION, launch at (%d, %d)." % [tile.x, tile.y])

				
					
				else:
					launch_missile(get_global_mouse_position(), tile, range)
					add_message("Missile Launched at (%d, %d)." % [tile.x, tile.y])
				add_message("Blast Radius: " + str(range))
				
				


				print("Range is " + str(range))
				#blow_up(tile, range)
				map[tile.y][tile.x] = 0
				#$Grid.erase_cell(0, tile)
				missiles -= 1
				$MissileButton.text = "Missiles: " + str(missiles)
				if !missileFlying and missiles == 0 and !dying:
					if not check_turn_over() && missiles == 0:
						add_message("You ran out of missiles!")
						dying = true
						game_over()
						
						#$deathTimer.start()
					launching = false
	if !addingCamps and !missileFlying and !dying:
		if not check_turn_over():
			if missiles == 0:
				dying = true
				add_message("You ran out of missiles!")
				game_over()
				#$deathTimer.start()
			
			elif totalCamps == 0:
				add_message("No more survivor camps!")
				game_over()
				dying = true
				
				#$deathTimer.start()
		#check_turn_over()

func createZombieCamps(camps):
	var counter = 0
	while counter < camps:
		var row = randi_range(0, 6)
		var col = randi_range(0, 9)
		
		
		if map[row][col] == 0:
			map[row][col] = 1
			var pos = Vector2i(col, row)
			var atlas = Vector2i(0, 0)
			if turn_count < 5:
				mark_adjacent_cells_as_unavailable(row, col)
			$Grid.set_cell(0, pos, 2, atlas)
			counter += 1
			add_message("Zombie camp created at (%d, %d)." % [col, row])
			
func mark_adjacent_cells_as_unavailable(row, col):
	if row > 0:
		if map[row - 1][col] == 0:
			map[row - 1][col] = -1
	if row < 6:
		if map[row + 1][col] == 0:
			map[row + 1][col] = -1
	if col > 0:
		if map[row][col - 1] == 0:
			map[row][col - 1] = -1
	if col < 9:
		if map[row][col + 1] == 0:
			map[row][col + 1] = -1
	if row > 0 and col > 0:
		if map[row - 1][col - 1] == 0:
			map[row - 1][col - 1] = -1
	if row > 0 and col < 9:
		if map[row - 1][col + 1] == 0:
			map[row - 1][col + 1] = -1
	if row < 6 and col > 0:
		if map[row + 1][col - 1] == 0:
			map[row + 1][col - 1] = -1
	if row < 6 and col < 9:
		if map[row + 1][col + 1] == 0:
			map[row + 1][col + 1] = -1

func _on_add_camp_pressed():
	if addingCamps:
		addingCamps = false
		if campCount < 1:
			$AddCamp.text = "Add (Camps: " + str(totalCamps) + ")"
		else:
			$AddCamp.text = "Edit (Camps: " + str(totalCamps) + ")"
			CampsFin = true
			print_distances()
	elif not launching:
		addingCamps = true
		$AddCamp.text = "Save (Camps: " + str(totalCamps) + ")"
		CampsFin = false

func _on_missile_button_pressed():
	if not launching:
		if not addingCamps and campCount > 0:
			$MissileButton.text = "Missiles: " + str(missiles)
			launching = true
			$MissileIcon.texture = preload("res://buttonPressed.png")

func print_distances():
	cure.clear()  # Clear the array to store new distances
	var survivor_positions = find_survivor_positions()
	var zombie_positions = find_zombie_positions()
	for survivor_pos in survivor_positions:
		var min_distance = null
		for zombie_pos in zombie_positions:
			var distance = abs(survivor_pos.x - zombie_pos.x) + abs(survivor_pos.y - zombie_pos.y)
			if min_distance == null or distance < min_distance:
				min_distance = distance
		if min_distance != null:
			cure.append(min_distance)
	return cure

func find_zombie_positions():
	var positions = []
	for row in range(map.size()):
		for col in range(map[row].size()):
			if map[row][col] == 1:
				positions.append(Vector2i(col, row))
	return positions

func find_survivor_positions():
	var positions = []
	for row in range(map.size()):
		for col in range(map[row].size()):
			if map[row][col] == 2:
				positions.append(Vector2i(col, row))
	return positions

func check_turn_over():
	for row in map:
		# Return if zombies are found
		if 1 in row:
			TurnFin = false
			return false
	add_message("Turn over.")

	TurnFin = true
	Calc_Multiplyer()
	if TurnFin:
		turn_over_actions()

func blow_up(tile, r):
	#missileFlying = false
	$Explosion.play()
	$Grid.erase_cell(0, tile)
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
	if x > -1 and x < 7 and y > -1 and y < 10:
		map[x][y] = 0
		var tile = Vector2i(y, x)
		$Grid.erase_cell(0, tile)

func game_over():
	add_message("[color=red]You failed to liberate the islands.[/color]")
	#update_message_log()
	print("called gameoevr")
	$deathTimer.start()


func Calc_Multiplyer():
	# 2x for adjacent 
	# 1.5x for within 2 blocks
	# 1x for rest
	if TurnFin: 
		mult.clear()  # Ensure the multiplier array is cleared before calculation
		for pos in cure:
			if pos == 1:
				mult.append(10)
			elif pos == 2:
				mult.append(7.5)
			else:
				mult.append(5)
	
		# Sum up the mult array
		var total_multiplier = 0
		for value in mult:
			total_multiplier += value
		
		add_message("Total Multiplier: " + str(total_multiplier))
		$ProgressBar.value += total_multiplier
		update_message_log()
		check_cure_complete()
		print("Turn Over")

func turn_over_actions():
	$MissileIcon.texture = preload("res://button.png")
	var survivors = find_survivor_positions()
	totalCamps += survivors.size()
	$AddCamp.text = "Add (Camps: " + str(totalCamps) + ")"
	# Reset survivor camps
	for i in range(map.size()):
		for j in range(map[i].size()):
			if map[i][j] == 2:
				map[i][j] = 0
				var tile = Vector2i(j, i)
				$Grid.erase_cell(0, tile)
	campCount = 0
	
	

		
	# Generate more zombies
	createZombieCamps(2*turn_count + 4)

	# Increment turn counter
	turn_count += 1
	add_message("Turn Count: " + str(turn_count))

	# Reset missiles and turn off launching
	missiles = (turn_count * 2) + 3
	launching = false
	$MissileButton.text = "Missiles: " + str(missiles)
	update_message_log()

# Message log functions
func add_message(message: String):
	message_log_text += ">" + message + "\n"
	update_message_log()

func update_message_log():
	
	$RichTextLabel.text = message_log_text
	$RichTextLabel.call_deferred("minimum_size_changed")
	
func launch_missile(coords, tile, r):
	const MISSILE =  preload("res://missile.tscn")
	var new_missile = MISSILE.instantiate()

	$MissileLauncher.look_at(coords)
	new_missile.target = coords
	new_missile.range = r
	new_missile.tile = tile
	new_missile.main = self
	new_missile.look_at(coords)
	new_missile.global_position = $MissileLauncher.global_position
	new_missile.global_rotation = $MissileLauncher.global_rotation
	add_child(new_missile)



func _on_death_timer_timeout():
	print("timeoutd")
	get_tree().change_scene_to_file("res://game_over.tscn")


func check_cure_complete():
	if $ProgressBar.value >= 100:
		cure_complete()

func cure_complete():
	get_tree().change_scene_to_file("res://victory.tscn")
