#This file is the script for Enemy 1. Enemy 1 is dog that can walk around and
#sniffs the player when they are in front of them.

extends CharacterBody2D

@export var hitpoints = 3
var hits_taken = 0
@export var gravity = 100
var speed = 32
@onready var facing_right = true

func _ready():
	#Making sure the right sprite is active for the right animation.
	$Sprite2D.visible = true
	$Sprite2D2.visible = false
	$AnimationPlayer.play("walk")
	velocity.x = 50
	velocity.y = gravity

func _physics_process(_delta):
	move_and_slide()


# Change the direction of the sprite
func change_state():
	if facing_right:
		facing_right = false
	else:
		facing_right = true
	velocity.x *= -1
	$Sprite2D.scale.x *= -1
	$Sprite2D2.scale.x *= -1
	$Detect_player.scale.x *= -1


#Adds a hit point when hit and frees the node when it dies.
func take_damage():
	hits_taken += 1
	if hitpoints == hits_taken:
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


# When the body leaves the area the scales have to be right and the animation
# has to be set to walk.
func _on_detect_player_body_exited(_body: CharacterBody2D):
	if $Sprite2D.scale.x == 1 or $Sprite2D2.scale.x == 1 and facing_right:
		velocity.x = 50
	elif $Sprite2D.scale.x == -1 or $Sprite2D2.scale.x == -1 and facing_right:
		velocity.x = -50
	elif $Sprite2D.scale.x == 1 or $Sprite2D2.scale.x == 1 and !facing_right:
		velocity.x = -50
	elif $Sprite2D.scale.x == -1 or $Sprite2D2.scale.x == -1 and !facing_right:
		velocity.x = 50
	$Sprite2D.visible = true
	$Sprite2D2.visible = false
	$AnimationPlayer.play("walk")

# When a body is in front of you do the idle animation.
func _on_detect_player_body_entered(_body: CharacterBody2D):
	$Sprite2D.visible = false
	$Sprite2D2.visible = true
	velocity.x = 0
	$AnimationPlayer.play("idle")
