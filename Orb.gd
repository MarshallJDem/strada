extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


onready var material := get_surface_material(0)
onready var main = get_tree().get_root().get_node("Main");
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var time = 0
var activated = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	var val = (sin(time * 2 * PI / (4)) )/2
	var val2 = (sin(time * 2 * PI / (2)) )/2
	
	material.set_shader_param("dissolve_amount", 0.5 + val/4)
	material.set_shader_param("burn_size", 0.1 + val2/10)
	#material.set_shader_param("burn_size", val)
	#self.rotate(Vector3(1,1,0).normalized(), PI * delta / 5)
	
func _physics_process(delta: float) -> void:
	if activated:
		self.visible = false
	if $AddColor_Timer.time_left > 0:
		var material = main.get_node("Planet_Wilke/wilkeworld").get_surface_material(0)
		if main.current_world == 2:
			material = main.get_node("Planet_Woogie/woogieworld").get_surface_material(0)
		var progress = 1 - ($AddColor_Timer.time_left / $AddColor_Timer.wait_time)
		
		if main.current_world == 1:
			material.emission_energy = lerp(0,0.25,progress);
			material.albedo_color = Color(50.0/255.0, lerp(50.0/255.0, 200.0/255.0, progress), 50.0/255.0);
		if main.current_world == 2:
			material.emission_energy = lerp(0,3.5,progress);
			material.albedo_color = Color(lerp(50.0/255.0, 200.0/255.0, progress), lerp(50.0/255.0, 0.0/255.0, progress), lerp(50.0/255.0, 200.0/255.0, progress));
	if !activated and main.get_node("Player").global_transform.origin.distance_to(self.global_transform.origin) < 1:
		activate()
func activate():
	if main.current_world == 1:
		$AddColor_Timer.start();
		self.visible = false
		main.wilke_activated = true
		activated = true
		main.get_node("WilkeMusic").play()
	# Woogie
	elif main.current_world == 2:
		$AddColor_Timer.start();
		self.visible = false
		main.woogie_activated = true
		activated = true
		main.get_node("WoogieMusic").play()
