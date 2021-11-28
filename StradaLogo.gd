extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var start_y = 0
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	start_y = self.transform.origin.y


#Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	var change = sin((time * 2 * PI) / (2)) * 0.1
	var new_pos = start_y + change
	self.transform.origin.y = new_pos
