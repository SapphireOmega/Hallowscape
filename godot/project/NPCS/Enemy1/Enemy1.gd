extends CharacterBody2D

@export var hitpoints = 3
var hits_taken = 0
@export var gravity = 100
var speed = 32
@onready var facing_right = true

func _ready():
	$Sprite2D.visible = true
	$Sprite2D2.visible = false
	$AnimationPlayer.play("walk")
	velocity.x = 50
	velocity.y = gravity

func _physics_process(_delta):
	move_and_slide()

func change_state():
	print("changing state")
	if facing_right:
		facing_right = false
	else:
		facing_right = true
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


func _on_detect_player_body_exited(body: CharacterBody2D):
	if scale.x == 1 and facing_right:
		velocity.x = 50
	elif scale.x == -1 and facing_right:
		velocity.x = -50
	elif scale.x == 1 and !facing_right:
		velocity.x = -50
	elif scale.x == -1 and !facing_right:
		velocity.x = 50
	$Sprite2D.visible = true
	$Sprite2D2.visible = false
	$AnimationPlayer.play("walk")


func _on_detect_player_body_entered(body: CharacterBody2D):
	$Sprite2D.visible = false
	$Sprite2D2.visible = true
	velocity.x = 0
	$AnimationPlayer.play("idle")
