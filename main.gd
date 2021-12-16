extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var transition_start_y = 0

var has_transitioned = false

onready var terrain_pink = load("res://Terrain_Material_Pink.tres")
onready var terrain_blue = load("res://Terrain_Material.tres")
onready var terrain_green = load("res://Terrain_Material_Green.tres")
onready var portal_blue = load("res://Portal_Material_Blue.tres")
onready var portal_yellow = load("res://Portal_Material_Yellow.tres")


enum Control_Schemes { touchscreen, keyboard, controller};
var control_scheme = Control_Schemes.keyboard;

# Called when the node enters the scene tree for the first time.
func _ready():
	$Transition_Timer.connect("timeout", self, "_transition_complete")
	$Orb_Move_Timer.connect("timeout", self, "_orb_move_complete")
	pass # Replace with function body.

		
func _transition_complete():
	$Orb_Move_Timer.start()
	$WorldEnvironment.environment.adjustment_brightness = 0.5
	$WorldEnvironment.environment.adjustment_contrast = 1.5
	$WorldEnvironment.environment.adjustment_saturation = 0.01

var current_world = 0
var just_portaled = false

var just_portaled2 = false


var captured = false

func _input(event):
	if self.control_scheme == 1 and event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		captured = true


func _physics_process(delta):
	
	
	
	if OS.has_touchscreen_ui_hint():
		control_scheme = Control_Schemes.touchscreen;
	else:
		control_scheme = Control_Schemes.keyboard;
	
#
#	if $Transition_Timer.time_left > 0:
#		# First half
#		if($Transition_Timer.time_left > $Transition_Timer.wait_time/2):
#			var progress = ($Transition_Timer.wait_time - $Transition_Timer.time_left) / ($Transition_Timer.wait_time/2)
#			$Player.transform.origin.y = (150 * progress) + transition_start_y
#		# Second half
#		else:
#			var progress = ($Transition_Timer.wait_time - $Transition_Timer.time_left) / ($Transition_Timer.wait_time/2)
#			$WorldEnvironment.environment.background_energy = 0.0;
#			$Portal.visible = false
#			$Orb.visible = true
#			$StradaLogo.visible = false
#			$TerrainBody/TerrainMesh._activate_grey_world()
#
#	if $Orb_Move_Timer.time_left > 0:
#		var progress = ( $Orb_Move_Timer.wait_time  - $Orb_Move_Timer.time_left ) / $Orb_Move_Timer.wait_time
#		$Orb.transform.origin.y = lerp(0.7, 2.0, progress)
	
	
	#print($Player.transform.origin.distance_to($Portal.transform.origin));
	# Portal collision
	
	
	if current_world == 0:
		$Planet.visible = true
		$Planet_Wilke.visible = false
		$Planet_Woogie.visible = false
		# Character maker
		if $Player.transform.origin.distance_to($Planet/Portal.global_transform.origin) < 0.7:
			if !just_portaled:
				JavaScript.eval("enableReactVisibility()", true)
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				just_portaled = true
				captured = false
			else: 
				just_portaled = false
		# Wilke World portal
		if $Player.transform.origin.distance_to($Planet/Portal1.global_transform.origin) < 0.7:
			$Player.transform.origin = $Planet_Wilke/SpawnPoint.global_transform.origin
			$Player.rotation_degrees = Vector3(-90,0,0)
			current_world = 1
		# Woogie world portal
		if $Player.transform.origin.distance_to($Planet/Portal2.global_transform.origin) < 0.7:
			$Player.transform.origin = $Planet_Woogie/SpawnPoint.global_transform.origin
			$Player.rotation_degrees = Vector3(0,0,0)
			current_world = 2
	if current_world == 1:
		$Planet.visible = false
		$Planet_Wilke.visible = true
		$Planet_Woogie.visible = false
		if $Player.transform.origin.distance_to($Planet_Wilke/Portal.global_transform.origin) < 0.7:
			$Player.transform.origin = Vector3(0,40,20)
			$Player.rotation_degrees = Vector3(0,0,0)
			current_world = 0
	if current_world == 2:
		$Planet.visible = false
		$Planet_Wilke.visible = false
		$Planet_Woogie.visible = true
		if $Player.transform.origin.distance_to($Planet_Woogie/Portal.global_transform.origin) < 0.7:
			$Player.transform.origin = Vector3(0,40,20)
			$Player.rotation_degrees = Vector3(0,0,0)
			current_world = 0
		
	
