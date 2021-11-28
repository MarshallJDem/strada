extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var transition_start_y = 0

var has_transitioned = false


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
	if $Player.transform.origin.distance_to($Portal.transform.origin) < 0.7:
		JavaScript.eval("enableReactVisibility()", true)

#func _orb_move_complete():
#	$Orb.transform.origin.y = 2.0
#	$SpeechBubble.visible = true
