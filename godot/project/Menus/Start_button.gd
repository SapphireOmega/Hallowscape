extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	button_up.connect(_on_start_button_up)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_start_button_up():
	disabled = true
