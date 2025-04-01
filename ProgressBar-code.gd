extends ProgressBar



# Called when the node enters the scene tree for the first time.
func _ready():
	var x = randi_range(0, 100)
	self.value = x


