extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


onready var material := get_surface_material(0)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var time = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	var val = (sin(time * 2 * PI / (4)) )/2
	var val2 = (sin(time * 2 * PI / (2)) )/2
	
	material.set_shader_param("dissolve_amount", 0.5 + val/4)
	material.set_shader_param("burn_size", 0.1 + val2/10)
	#material.set_shader_param("burn_size", val)
	self.rotate(Vector3(1,1,0).normalized(), PI * delta / 5)
