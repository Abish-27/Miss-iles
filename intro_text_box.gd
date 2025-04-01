extends CanvasLayer

@onready var textbox = $MarginContainer
@onready var label = $MarginContainer/HBoxContainer/Label
@onready var tween = get_tree().create_tween()
# Called when the node enters the scene tree for the first time.
const readRate = 0.05


func _ready():
	add_text("Year: 1989")



func add_text(next_text):
	label.text = next_text
	textbox.show()
	tween.tween_property(label, "visible_characters", [1], len(next_text) * readRate).from(0).finished
	#tween.connect("finished", on_tween_finished)



func _process(delta):
	pass
