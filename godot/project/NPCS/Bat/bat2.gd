extends CharacterBody2D

@export var hitpoints = 2
var hits_taken = 0

@onready var animation = $AnimationPlayer

@export var speed = 60

var in_range = false
var x_dir = -1
var face_direction := -1

var dir
@export var max_travel_dist = 400

@export var player: CharacterBody2D
@onready var nav_ag := $NavigationAgent2D as NavigationAgent2D
@onready var spawn = self.position

func _ready():
	$Attack_player.visible = false
	$Attack_player.monitoring = false
	$AttackSprite.visible = false
	$IdleSprite.visible = true
	animation.queue("idle")
	makepath()

func set_direction(hor_direction) -> void:
	# This is purely for visuals
	# Turning relies on the scale of the player
	# To animate, only scale the sprite
	if hor_direction == 0:
		return

#	print(hor_direction)
	$IdleSprite.apply_scale(Vector2(hor_direction * face_direction, 1)) # flip
	$AttackSprite.apply_scale(Vector2(hor_direction * face_direction, 1))
	$Attack_player.apply_scale(Vector2(hor_direction * face_direction, 1))
	$Detect_player.apply_scale(Vector2(hor_direction * face_direction, 1))
	face_direction = hor_direction # remember direction

func _physics_process(delta):
	makepath()
	dir = nav_ag.get_next_path_position() - global_position
	velocity = dir.normalized() * speed
	
	if abs(player.position.x - position.x) < 30:
		x_dir = 0
		velocity.x = 0
	
	if almost_equal(self.position, spawn): x_dir = -1
	else:
		if dir.x > 0: x_dir = 1
		elif dir.x < 0: x_dir = -1
		else: x_dir = 0
	
	set_direction(x_dir)
	move_and_slide()
	
	if in_range:
		animation.queue("attack")
	elif animation.current_animation == "attack":
		if animation.animation_finished:
			pass
	else:
		animation.queue("idle")

	for ani in animation.get_queue():
		animation.play(ani)


func almost_equal(a, b) -> bool:
	if abs(a.x - b.x) < 1 and abs(a.y - b.y) < 1:
		return true
	else:
		return false


func makepath() -> void:
	if player.position.distance_to(spawn) > max_travel_dist:
		nav_ag.target_position = spawn
	elif player.position.distance_to(nav_ag.target_position) < 10:
		pass
	else:
		nav_ag.target_position = player.position


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
	if $Attack_player.monitoring and body.is_in_group("player"):
		body.take_damage()
		print(StageManager.health1)
		if StageManager.health1 == 0:
			StageManager.kill_players()
			StageManager.health1 = 3



func _on_animation_player_animation_finished(anim_name):
	if in_range == false:
		$Attack_player.visible = false
		$AttackSprite.visible = false
		$IdleSprite.visible = true
		animation.queue("idle")
