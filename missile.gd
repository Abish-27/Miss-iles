extends Node2D

@export var target : Vector2
@export var range : int
@export var tile : Vector2
#@export var main : Main
var exploding = false
#@onready var main = preload("res://main.tscn")
@onready var main = get_parent()

func _ready():
	$Anim.play("default")
	

func _process(delta):
	if !exploding:
		const SPEED = 500
		var direction = Vector2.RIGHT.rotated(rotation)
		if abs(global_position.x - target.x) < 5 and abs(global_position.y - target.y) < 5 :
			exploding = true
			#$Anim.speed_scale = 2
			$Anim.play("explode")
			$deathTimer.start()
			main.blow_up(tile, range)
			
		position += direction * SPEED * delta
	


func _on_death_timer_timeout():
	main.missileFlying = false
	queue_free()
	
	
