extends CharacterBody2D

func slide(delta: float, speed: float):
	self.position.x += delta * speed
	move_and_slide()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
