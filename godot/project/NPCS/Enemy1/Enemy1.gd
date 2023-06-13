extends CharacterBody2D

@export var hitpoints = 3
var hits_taken = 0
@export var gravity = 10
var speed = 32




func _ready():
	$AnimationPlayer.play("walk")
	velocity.x = 50
	velocity.y = gravity

func _physics_process(_delta):
	move_and_slide()

func change_state():
	print("im here")
	velocity.x *= -1
	scale.x *= -1
	

func take_damage():
	## hit animation ##
	hits_taken += 1
	print("hit taken")
	if hitpoints == hits_taken:
		print("died")
		var t = Timer.new()
		t.set_wait_time(0.1)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		await t.timeout
		## Death animation ##
		t.set_wait_time(0.1)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		await t.timeout
		t.queue_free()
		queue_free()
