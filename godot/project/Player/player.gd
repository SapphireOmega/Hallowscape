extends CharacterBody2D

@export var speed = 150
@export var gravity = 30
@export var jump_force = 500
@export var max_jump_force = 3000
@export var double_jump_force = 300
@export var face_dir = 1

var spawn_point: Vector2

var player_state = animation_states.MOVE
enum animation_states {MOVE, ATTACK, JUMP, FALL, LAND}

var has_jumped = false
var has_double_jumped = false

func _ready() -> void:
	spawn_point = self.position
	
func die() -> void:
	self.position = spawn_point

func _physics_process(delta):
	velocity.y += gravity
	
	if is_on_floor():
		velocity.y = 0

	if player_state == animation_states.MOVE:
		move()
	if player_state == animation_states.ATTACK:
		attack()
	if player_state == animation_states.JUMP:
		jump()
	if player_state == animation_states.FALL:
		fall()
	if player_state == animation_states.LAND:
		land()

	move_and_slide()

	
func move():
	var movement = Input.get_axis("move_left", "move_right")
	velocity.x = speed * movement

	set_direction(movement)
	update_move_animation(movement)
	
	if Input.is_action_just_pressed("attack"):
		player_state = animation_states.ATTACK
		
	if Input.is_action_just_pressed("jump"):
		player_state = animation_states.JUMP
		
	if !is_on_floor():
		player_state = animation_states.FALL
		
	if has_jumped && is_on_floor():
		player_state = animation_states.LAND


func attack():
	$AnimationPlayer.play("attack")
	
func attack_finished():
	player_state = animation_states.MOVE
	
	
func jump():
	var movement = Input.get_axis("move_left", "move_right")
	velocity.x = speed * movement
	$AnimationPlayer.play("jump")
	if !has_jumped && is_on_floor():
		if velocity.y > -max_jump_force:
			print("hoi")
			velocity.y += -jump_force
		has_jumped = true
	elif has_jumped && !has_double_jumped && !is_on_floor():
		if Input.is_action_just_pressed("jump"):
			print("in double jump")
			velocity.y += -double_jump_force
			has_double_jumped = true
		
	if velocity.y > 0:
		player_state = animation_states.FALL


func jump_finished():
	print("falling in 2")
	player_state = animation_states.FALL


func fall():
	$AnimationPlayer.play("fall")

func fall_finished():
	player_state = animation_states.LAND


func land():
	if is_on_floor() && has_jumped:
		print("hoi")
		has_jumped = false
		has_double_jumped = false
	$AnimationPlayer.play("land")

func land_finished():
	player_state = animation_states.MOVE


#functie zodat poppetje goede kant op kijkt
func set_direction(movement):
	if movement != 0: #niet nodig bij stilstaan
		apply_scale(Vector2(movement * face_dir, 1)) # flip
		face_dir = movement # remember direction
		

func update_move_animation(movement):
	if movement != 0:
		$AnimationPlayer.play("run")
	else:
		$AnimationPlayer.play("idle")
		
		
	

