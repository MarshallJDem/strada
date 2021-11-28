extends MeshInstance

export var material: SpatialMaterial
var intensity = 4

var blue_albedo = "546fdb"
var blue_emission = "001bff"
var grey_albedo = "7c7c7c"
var grey_emission = "131313"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Ground texture light breathing animation lengths
var illuminating = 4.0
var illuminated = 7.0
var darkening = 8.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$BreathingTimer.wait_time = illuminating + illuminated + darkening
	$BreathingTimer.start()
	material.emission_energy = 0
	material.albedo_color = Color(blue_albedo)
	material.emission = Color(blue_emission)
	pass # Replace with function body.

func _activate_grey_world():
	intensity = 3
	material.albedo_color = Color(grey_albedo)
	material.emission = Color(grey_emission)

var time = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Illuminating ground animation
	if ($BreathingTimer.time_left >= $BreathingTimer.wait_time - illuminating):
		var progress = ($BreathingTimer.wait_time - $BreathingTimer.time_left) / illuminating
		material.emission_energy = (progress*intensity)
	# Illuminated ground animation
	elif ($BreathingTimer.time_left >= $BreathingTimer.wait_time - (illuminating + illuminated)):
		material.emission_energy = (intensity)
	# Darkening ground animation
	elif ($BreathingTimer.time_left >= $BreathingTimer.wait_time - (illuminating + illuminated + darkening)):
		var progress = ($BreathingTimer.wait_time - $BreathingTimer.time_left - illuminating - illuminated) / (darkening)
		material.emission_energy = ((1-progress)*intensity)
	
