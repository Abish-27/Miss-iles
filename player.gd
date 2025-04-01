extends CharacterBody2D

class_name Player

const SPEED = 1
const maxAngle = deg_to_rad(65)
var health = 5
@export var living = true

func _ready():
	$shootingTimer.start()
	
func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	#velocity = direction * SPEED
	
	if Input.is_action_pressed("left") :
		if $Gun.rotation > -maxAngle:
			$Gun.rotation -= 2 * delta
	
	if Input.is_action_pressed("right"):
		if $Gun.rotation < maxAngle:
			$Gun.rotation += 2 * delta
		#move_and_slide()
		
	var mobs = $Hurtbox.get_overlapping_bodies()
	if mobs.size() > 1:
		health -= 1 * (mobs.size()-1) * delta
		
	
	if health < 0:
		var main = get_parent()
		main.get_node("zombieSpawner").stop()
		$shootingTimer.stop()
		#queue_free()
		living = false
		get_tree().change_scene_to_file("res://home.tscn")

		
		
	
	
		
func shoot():
	const BULLLET =  preload("res://bullet.tscn")
	var new_bullet = BULLLET.instantiate()
	new_bullet.position = $Gun/ShootingPoint.position
	new_bullet.global_rotation = $Gun.global_rotation
	
	add_child(new_bullet)
	

	


func _on_shooting_timer_timeout():
	shoot() # Replace with function body.



