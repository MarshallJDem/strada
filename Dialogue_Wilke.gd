extends Spatial

var main;

func _ready():
	$View.texture = $Viewport.get_texture()
	main = get_tree().get_root().get_node("Main")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var orb = get_parent()
	var player = get_tree().get_root().get_node("Main/Player")
	#avatar.rotation_degrees.y = $View.rotation_degrees.y
	var last_y = orb.rotation_degrees.y
	orb.look_at(player.transform.origin, player.transform.basis.z)
	var distance = orb.rotation_degrees.y - last_y
	if distance < 180:
		distance += 360
	if distance > 180:
		distance -= 360
	orb.rotation_degrees.y = last_y + (clamp(distance, -360, 360) * delta * 2)
	orb.rotation_degrees.x = 0
	orb.rotation_degrees.z = 0
	$View.look_at(player.transform.origin, player.transform.basis.z)
	$View.rotation_degrees.x = 0
	
	var distance_to_player = self.global_transform.origin.distance_to(main.get_node("Player").global_transform.origin)
	if distance_to_player > 4.5:
		self.visible = false
	elif distance_to_player < 2.5:
		self.visible = true
	else:
		self.visible = true
		var progress = 1 - (distance_to_player - 2.5)/(4.5-2.5)
		$View.modulate.a = progress

func _next_clicked():
	if !get_parent().activated:
		get_parent().activate()
	
