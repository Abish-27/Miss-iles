extends Node2D


var wave = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$zombieSpawner.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_zombie_spawner_timeout():
	var zombieNum = (2 * wave) + 1
	spawn_zombies(zombieNum)
	wave += 1
	
func spawn_zombies(num):
	for i in num:
		const ZOMBIE =  preload("res://zombie.tscn")
		var zombie = ZOMBIE.instantiate()
		zombie.global_position.x = randi_range(-400, 2400)
		zombie.global_position.y = randi_range(-100, -20)
		add_child(zombie)
