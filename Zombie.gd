extends CharacterBody2D

var health = 6
#@onready var player = get_node("res://player.tscn")
@onready var player = get_node("/root/GameOver/Player")
const SPEED = 40.0


func _ready():
	$zombieAnim.play("walk")
	


func _physics_process(delta):
	if player.living:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * SPEED
		move_and_slide()
	
	
func takeDamage():
	health -= 1
	if health == 0:
		queue_free()



