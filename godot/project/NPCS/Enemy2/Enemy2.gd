# This file contains functions that determine the behaviour of enemy 2.
# Enemy 2 follows a player when it is in range and attacks when player gets 
# too close.

extends CharacterBody2D

@export var hitpoints = 3
var hits_taken = 0

@onready var animation = $AnimationPlayer

@export var speed = 40
@export var gravity = 10

var vision = 250
var player_pos
var target_pos
@onready var player = get_parent().get_node("player")

var in_range = false
var x_dir = -1
var face_direction := -1


func _ready():
	#Making sure the right sprite is active for the right animation.
	$Attack_player.visible = false
	$Attack_player.monitoring = false
	$AttackSprite.visible = false
	$IdleSprite.visible = true
	animation.queue("idle")

func _process(_delta):
	# Move towards the player if the player is within the vision area.
	if abs(player.position.x - position.x) > vision:
		velocity.x = 0
	elif player.position.x - position.x > 0:
		if player.position.x < 0.9*position.x:
			velocity.x = 0
			x_dir = 1
		else:
			x_dir = 1
			velocity.x = speed
	elif player.position.x - position.x < 0:
		if player.position.x > 1.1*position.x:
			velocity.x = 0
			x_dir = -1
		else:
			x_dir = -1
			velocity.x = -speed
			
	if abs(player.position.x - position.x) < 30:
		x_dir = 0
		velocity.x = 0
		
	set_direction(x_dir)

func set_direction(hor_direction) -> void:
	# This is purely for visuals
	# Turning relies on the scale of the player
	# To animate, only scale the sprite
	if hor_direction == 0:
		return
	apply_scale(Vector2(hor_direction * face_direction, 1)) # flip
	face_direction = hor_direction # remember direction

func _physics_process(delta):
	move_and_collide(velocity * delta)
	if in_range:
		animation.queue("attack")
	elif animation.current_animation == "attack":
		if animation.animation_finished:
			pass
	else:
		animation.queue("idle")

	for ani in animation.get_queue():
		animation.play(ani)

func take_damage():
	#Adds a hit point when hit and frees the node when it dies.
	## hit animation ##
	hits_taken += 1
	if hitpoints == hits_taken:
		## Death animation ##
		queue_free()


#Activates the attack sprite if the player is close enough.
func body_enter_attack(_body: CharacterBody2D):
	$AttackSprite.visible = true
	$IdleSprite.visible = false
	in_range = true

func body_out_of_range(_body: CharacterBody2D):
	in_range = false


#Every hit the player loses one health point.
func damage_player(body: CharacterBody2D):
	if $Attack_player.monitoring and body.is_in_group("player"):
		StageManager.health1 -= 1
		if StageManager.health1 == 0:
			StageManager.kill_players(body.player_id)
	


#Making sure the idle animation only plays when the attack animation is finished.
func _on_animation_player_animation_finished(_anim_name):
	if in_range == false:
		$Attack_player.visible = false
		$AttackSprite.visible = false
		$IdleSprite.visible = true
		animation.queue("idle")
