extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# physics
var moveSpeed : float = 5.0
var jumpForce : float = 2.5
var gravity : float = 8.0
var vel : Vector3 = Vector3(0,0,0)
var main;

var mouse_sens = 0.3
var camera_anglev=0
func _ready():
	main = get_tree().get_root().get_node("Main")
func _input(event):
	
		
	if main.captured and main.control_scheme == 1:
		if event is InputEventMouseMotion:
			rotate(self.transform.basis.z.normalized(),deg2rad(-event.relative.x*mouse_sens))
			var changev=-event.relative.y*mouse_sens
			if camera_anglev+changev>-50 and camera_anglev+changev<50:
				camera_anglev+=changev
				$Camera.rotate_x(deg2rad(changev))
				
	elif main.control_scheme == 0 and event is InputEventScreenDrag:
		if event.index != get_tree().get_root().get_node("Main/GUI/JoystickL")._touch_index:
			rotate(self.transform.basis.z.normalized(),deg2rad(-event.relative.x*mouse_sens))
			var changev=-event.relative.y*mouse_sens
			if camera_anglev+changev>-50 and camera_anglev+changev<50:
				camera_anglev+=changev
				$Camera.rotate_x(deg2rad(changev))
			

var up_vel = 0
func _physics_process(delta):
	# reset the x and z velocity
	vel.x = 0
	vel.z = 0

	var input = Vector2()
	
	# Check if we clicked on dialogue
	if Input.is_action_just_released("click"):
		if $Camera/RayCast.is_colliding():
			var collider = $Camera/RayCast.get_collider()
			var dialogue = collider.get_parent().get_parent()
			dialogue._next_clicked();
#

	if get_tree().get_root().get_node("Main").control_scheme == 1:
		# movement inputs
		if Input.is_action_pressed("move_forward"):
			input.y -= 1
		if Input.is_action_pressed("move_backward"):
			input.y += 1
		if Input.is_action_pressed("move_left"):
			input.x -= 1
		if Input.is_action_pressed("move_right"):
			input.x += 1
	else:
		input.y += get_tree().get_root().get_node("Main/GUI/JoystickL").output.y
		input.x += get_tree().get_root().get_node("Main/GUI/JoystickL").output.x
			

	input = input.normalized()
	
	var gravity_origin = Vector3.ZERO
	if main.current_world == 2:
		gravity_origin = main.get_node("Planet_Woogie").transform.origin
	
	# Do this only on woogie
	if main.current_world == 2:
		self.look_at(gravity_origin, self.transform.basis.y)
	
	# get the forward and right directions
	var right = self.transform.basis.x
	var up = self.transform.basis.y
	var forward = self.transform.basis.z


	# set the velocity
#	vel.x =  input.x * moveSpeed
#	vel.y =  input.y * moveSpeed
#	vel.z -=  gravity * delta
	if main.current_world != 2:
		up = self.transform.basis.y
		right = self.transform.basis.x
		forward = Vector3.UP
 
	var new_vel = Vector3.ZERO
	# apply gravity if we arent on the floor
	new_vel += (forward * (up_vel))
	if !is_on_floor():
		up_vel -= gravity * delta
	new_vel += right * input.x * moveSpeed
	new_vel += -up * input.y * moveSpeed
	# move the player
	vel = move_and_slide(new_vel, self.transform.basis.z, true)
	
	if(is_on_floor()):
		up_vel = 0
	# jumping
	if Input.is_action_pressed("jump") and is_on_floor():
		vel.y = jumpForce
		up_vel = jumpForce
		print("jump")
	
	self.orthonormalize()
	
