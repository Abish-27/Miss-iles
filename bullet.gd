extends Area2D


# Called when the node enters the scene tree for the first time.
var range = 900
var distance = 0


func _physics_process(delta):
	const SPEED = 1000
	#var direction = Vector2.UP
	var direction = Vector2.UP.rotated(rotation)
	global_position += delta * direction * SPEED
	
	distance += delta * SPEED
	if distance > range:
		queue_free()
	
	
	
	
	


func _on_body_entered(body):
	queue_free()
	if body.has_method("takeDamage"):
		body.takeDamage()
