extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


onready var main = get_tree().get_root().get_node("Main")
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ColorRect.visible = !main.captured
