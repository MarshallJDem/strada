extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# physics
var moveSpeed : float = 1.0
var jumpForce : float = 2.5
var gravity : float = 8.0
var vel : Vector3 = Vector3(0,0,0)

var mouse_sens = 0.3
var camera_anglev=0
var captured = false

func _ready():
	pass
func _input(event):
	var main = get_tree().get_root().get_node("Main")
	if main.control_scheme == 1 and event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		captured = true
		
	if captured and main.control_scheme == 1 and event is InputEventMouseMotion:
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
			

func _physics_process(delta):
	# reset the x and z velocity
	vel.x = 0
	vel.z = 0

	var input = Vector2()


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
	
	
	self.look_at(Vector3.ZERO, self.transform.basis.y)
	
	# get the forward and right directions
	var right = self.transform.basis.x
	var up = self.transform.basis.y
	var forward = self.transform.basis.z


	# set the velocity
#	vel.x =  input.x * moveSpeed
#	vel.y =  input.y * moveSpeed
#	vel.z -=  gravity * delta
	var grav_direction = (self.transform.origin - Vector3.ZERO).normalized()
 
	var new_vel =  Vector3.ZERO
	# apply gravity if we arent on the floor
	if !is_on_floor():
		new_vel -= forward * gravity
	new_vel += right * input.x * moveSpeed
	new_vel += -up * input.y * moveSpeed
	# move the player
	vel = move_and_slide(new_vel, self.transform.basis.z, true)
	
	# jumping
	if Input.is_action_pressed("jump") and is_on_floor():
		vel.y = jumpForce
	
	self.orthonormalize()
	
