extends Node2D



 

func _on_game_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
	



func _on_tutorial_button_pressed():
	get_tree().change_scene_to_file("res://tutorial.tscn")


func _on_score_button_pressed():
	get_tree().change_scene_to_file("res://credits.tscn") # Replace with function body.
