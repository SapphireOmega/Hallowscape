extends CharacterBody2D

@export var gravity = 1100

func slide(delta: float, speed: float):
	self.position.x += delta * speed
	move_and_slide()

func _physics_process(delta) -> void:
	self.velocity.y += gravity * delta
	move_and_slide()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
