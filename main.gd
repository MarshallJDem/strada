extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var transition_start_y = 0

var has_transitioned = false

var wilke_activated = false
var woogie_activated = false

onready var terrain_pink = load("res://Terrain_Material_Pink.tres")
onready var terrain_blue = load("res://Terrain_Material.tres")
onready var terrain_green = load("res://Terrain_Material_Green.tres")

enum Control_Schemes { touchscreen, keyboard, controller};
var control_scheme = Control_Schemes.keyboard;

var portals_active = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	$Transition_Timer.connect("timeout", self, "_transition_complete")
	$Orb_Move_Timer.connect("timeout", self, "_orb_move_complete")
	$Planet/Portal.active = false
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
	
	if !portals_active:
		$Planet/Portal1.active = false
		$Planet/Portal2.active = false
	else:
		$Planet/Portal1.active = true
		$Planet/Portal2.active = true
	
	if woogie_activated and wilke_activated:
		$Planet/Portal.active = true
	
	
	if OS.has_touchscreen_ui_hint():
		control_scheme = Control_Schemes.touchscreen;
	else:
		control_scheme = Control_Schemes.keyboard;
	
	if Input.is_key_pressed(KEY_ESCAPE):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		captured = false 
	
	
	if current_world == 0:
		$Planet.visible = true
		$Planet_Wilke.visible = false
		$Planet_Woogie.visible = false
		# Character maker
		if $Player.transform.origin.distance_to($Planet/Portal.global_transform.origin) < 1:
			if !just_portaled and (woogie_activated and wilke_activated):
				JavaScript.eval("enableReactVisibility()", true)
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				just_portaled = true
				captured = false
			else: 
				just_portaled = false
		# Wilke World portal
		if $Player.transform.origin.distance_to($Planet/Portal1.global_transform.origin) < 1 and portals_active:
			$Player.transform.origin = $Planet_Wilke/SpawnPoint.global_transform.origin
			$Player.rotation_degrees = Vector3(-90,0,0)
			current_world = 1
		# Woogie world portal
		if $Player.transform.origin.distance_to($Planet/Portal2.global_transform.origin) < 1 and portals_active:
			$Player.transform.origin = $Planet_Woogie/SpawnPoint.global_transform.origin
			$Player.rotation_degrees = Vector3(0,0,0)
			current_world = 2
	if current_world == 1:
		$Planet.visible = false
		$Planet_Wilke.visible = true
		$Planet_Woogie.visible = false
		if wilke_activated:
			$Planet_Wilke/Portal.active = true
			if $Player.transform.origin.distance_to($Planet_Wilke/Portal.global_transform.origin) < 1:
				$Player.transform.origin = Vector3(0,10,-20)
				$Player.rotation_degrees = Vector3(-90,180,0)
				current_world = 0
		else:
			$Planet_Wilke/Portal.active = false
	if current_world == 2:
		$Planet.visible = false
		$Planet_Wilke.visible = false
		$Planet_Woogie.visible = true
		if woogie_activated:
			$Planet_Woogie/Portal.active = true
			if $Player.transform.origin.distance_to($Planet_Woogie/Portal.global_transform.origin) < 1:
				$Player.transform.origin = Vector3(0,10,-20)
				$Player.rotation_degrees = Vector3(-90,180,0)
				current_world = 0
		else:
			$Planet_Woogie/Portal.active = false
			
	
