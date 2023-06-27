extends ParallaxLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	var mot = Input.get_last_mouse_velocity().x
#	print(Input.get_last_mouse_velocity().x)
	var mot = 35
	motion_offset.x -= delta*(mot*0.06+32)
