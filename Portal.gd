extends MeshInstance

var active = false
export var mat: SpatialMaterial; 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active:
		set_surface_material(0, mat)
		$Portal2.visible = true
	else:
		set_surface_material(0, null);
		$Portal2.visible = false
