extends CharacterBody2D

@export var hitpoints = 3
var hits_taken = 0

@onready var Animationtree : AnimationTree = $AnimationTree
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
	$Attack_player.visible = false
	$Attack_player.monitoring = false
	$AttackSprite.visible = false
	$IdleSprite.visible = true
	animation.queue("idle")

func _process(delta):
	# Move towards the player if the player is within a certain area.
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
	## hit animation ##
	hits_taken += 1
	print("hit taken")
	if hitpoints == hits_taken:
		print("died")
		## Death animation ##
		queue_free()

func body_enter_attack(body: CharacterBody2D):
	$AttackSprite.visible = true
	$IdleSprite.visible = false
	in_range = true

func body_out_of_range(body: CharacterBody2D):
	in_range = false

func damage_player(body: CharacterBody2D):
	if $Attack_player.monitoring == true:
		print("player hit")

func _on_animation_player_animation_finished(anim_name):
	if in_range == false:
		$Attack_player.visible = false
		$AttackSprite.visible = false
		$IdleSprite.visible = true
		animation.queue("idle")
