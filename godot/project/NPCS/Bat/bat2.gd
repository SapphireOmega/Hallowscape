# This file contains functions that create the bat enemy.
# The bat can fly around in a Navigation region en follow the closest player.
# When the player is in certain range of the bat, the bat will attack.

extends CharacterBody2D

@export var hitpoints = 3
var hits_taken = 0



@export var speed = 60
var dir
@export var max_travel_dist = 400

var in_range = false
var x_dir = -1
var face_direction := -1

@export var player1: CharacterBody2D
@export var player2: CharacterBody2D
@onready var nav_ag := $NavigationAgent2D as NavigationAgent2D
@onready var animation = $BatAnimationPlayer
@onready var spawn = self.position

@onready var dying = false


func _ready():
	#Making sure the right sprite is active for the right animation.
	$Attack_player.visible = false
	$Attack_player.monitoring = false
	$AttackSprite.visible = false
	$IdleSprite.visible = true
	$DeathSprite.visible = false
	animation.queue("idle")
	makepath()


func set_direction(hor_direction) -> void:
	# This is purely for visuals
	# Turning relies on the scale of the player
	# To animate, only scale the sprite
	if hor_direction == 0:
		return

	$IdleSprite.apply_scale(Vector2(hor_direction * face_direction, 1)) # flip
	$AttackSprite.apply_scale(Vector2(hor_direction * face_direction, 1))
	$DeathSprite.apply_scale(Vector2(hor_direction * face_direction, 1))
	$Attack_player.apply_scale(Vector2(hor_direction * face_direction, 1))
	$Detect_player.apply_scale(Vector2(hor_direction * face_direction, 1))
	face_direction = hor_direction # remember direction


func _physics_process(_delta):
	makepath()
	dir = nav_ag.get_next_path_position() - global_position
	velocity = dir.normalized() * speed
	
	if abs(player1.position.x - position.x) < 30 or abs(player2.position.x - position.x) < 30:
		x_dir = 0
		velocity.x = 0
	
	if almost_equal(self.position, spawn): x_dir = -1
	else:
		if dir.x > 0: x_dir = 1
		elif dir.x < 0: x_dir = -1
		else: x_dir = 0

	set_direction(x_dir)
	move_and_slide()
	
	if in_range and !dying:
		animation.queue("attack")
	elif animation.current_animation == "attack" and !dying:
		if animation.animation_finished:
			pass
	elif !dying:
		animation.queue("idle")
	else:
		animation.queue("die")

	for ani in animation.get_queue():
		animation.play(ani)


# Checks if the diff between a and b is smaller than 1.
func almost_equal(a, b) -> bool:
	if abs(a.x - b.x) < 1 and abs(a.y - b.y) < 1:
		return true
	else:
		return false


# This function is called every frame to calculate the path to the closest player.
func makepath() -> void:
	if player1.position.distance_to(spawn) > max_travel_dist and player2.position.distance_to(spawn) > max_travel_dist:
		nav_ag.target_position = spawn
	elif player1.position.distance_to(self.position) < 10 or player2.position.distance_to(self.position) < 10:
		pass
	else:
		if player1.position.distance_to(self.position) < player2.position.distance_to(self.position):
			nav_ag.target_position = player1.position
		else:
			nav_ag.target_position = player2.position


#Adds a hit point when hit and frees the node when it dies.
func take_damage():
	## hit animation ##
	hits_taken += 1
	if hitpoints == hits_taken:
		dying = true
		$IdleSprite.visible = false
		$AttackSprite.visible = false
		$DeathSprite.visible = true
		animation.stop(true)
		animation.clear_queue()
		animation.queue("die")
		
		var t = Timer.new()
		# Waits for the animation to finish.
		t.set_wait_time(0.7)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		await t.timeout
		
		queue_free()


# If the bat is not dying an attack can be initiated.
func body_enter_attack(_body):
	if !dying:
		$AttackSprite.visible = true
		$IdleSprite.visible = false
		in_range = true


func body_out_of_range(_body):
	in_range = false

# This function takes health from the player and kills them if the health is zero.
func damage_player(body):
	if body:
		if $Attack_player.monitoring and body.is_in_group("player"):
			body.take_damage()
			if StageManager.health1 == 0:
				StageManager.kill_players(body.player_id)
				StageManager.health1 = 3

#Making sure the idle animation only plays when the attack animation is finished.
func _on_animation_player_animation_finished(_anim_name):
	if in_range == false:
		$Attack_player.visible = false
		$AttackSprite.visible = false
		$IdleSprite.visible = true
		animation.queue("idle")
