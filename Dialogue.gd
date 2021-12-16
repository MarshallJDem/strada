extends Spatial

var s_dialogue = [
	"Hi, you don't look like you're from here.",
	"You're the first visitor we've had in StradaVerse since we lost everyone.",
	"Over a hundred years ago, an evil force wiped out the majority of the Stradarians. We were protectors of all artists in the StradaVerse. Stradarians and artists live together in harmony, with Stradarians providing resources and light for each planet to thrive and artists being the source of love and creativity.",
	"I'm protecting the Strada Generator, it's our last hope for saving the StradaVerse and artists in it.",
	"We're sensing energy signals from Wilke World and Woogie World. I think if we harmonize the energy from both artists, they will power the Generator. Can you help?",
	"Thank you. Follow the light and you'll never lose your way",
	# Hold
	"Wow! I can't believe it. The generator is back on. The biggest gift I can give to thank you is the power of the Original Creator.",
	"Soon, this portal will open and you'll discover what's always been waiting for you.Don't worry, there's other explorers like you. Go meet them.",
	
]
var u_dialogue = [
	"You're right. I'm not really sure where I am.",
	"Where did they go?",
	"Why are you here?",
	"How can I help?",
	"Yes",
	# Hold
	"Thank you, how?",
	
]

var s_dialogue_index = 0
var u_dialogue_index = 0

func _ready():
	$View.texture = $Viewport.get_texture()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Viewport/Label.text = s_dialogue[s_dialogue_index]
	$Viewport/Button.text = u_dialogue[u_dialogue_index]
	var avatar = get_tree().get_root().get_node("Main/StradaAvatar")
	var player = get_tree().get_root().get_node("Main/Player")
	#avatar.rotation_degrees.y = $View.rotation_degrees.y
	var last_y = avatar.rotation_degrees.y
	avatar.look_at(player.transform.origin, player.transform.basis.z)
	var distance = avatar.rotation_degrees.y - last_y
	if distance < 180:
		distance += 360
	if distance > 180:
		distance -= 360
	
	avatar.rotation_degrees.y = last_y + (clamp(distance, -360, 360) * delta)
	avatar.rotation_degrees.x = 0
	avatar.rotation_degrees.z = 0
	$View.look_at(player.transform.origin, player.transform.basis.z)
	$View.rotation_degrees.x = 0

func _next_clicked():
	print("woop");