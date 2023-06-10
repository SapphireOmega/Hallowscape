extends CharacterBody2D

@export var speed = 300
@export var gravity = 30
@export var jump_force = 600
@export var double_jump_force = 300
@export var face_dir = 1

var player_state = animation_states.MOVE
enum animation_states {MOVE, ATTACK, JUMP, FALL, LAND}

var has_jumped = false
var has_double_jumped = false


func _physics_process(delta):
	velocity.y += gravity

	match player_state:
		animation_states.MOVE:
			move()
		animation_states.ATTACK:
			attack()
		animation_states.JUMP:
			jump()
		animation_states.FALL:
			fall()
		animation_states.LAND:
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
		
#	if !is_on_floor():
#		print("vallen op andere plek")
#		player_state = animation_states.FALL
		
#	if has_jumped && is_on_floor():
#		player_state = animation_states.LAND


func attack():
	$AnimationPlayer.play("attack")
	
func attack_finished():
	player_state = animation_states.MOVE
	
	
func jump():
	$AnimationPlayer.play("jump")
	#is_on_floor pakt ie niet
	print(is_on_floor())
	if !has_jumped && is_on_floor():
		velocity.y = -jump_force
		has_jumped = true
	elif !has_double_jumped:
		velocity.y = -double_jump_force
		has_double_jumped = true

func jump_finished():
	player_state = animation_states.FALL


func fall():
	if !is_on_floor():
		velocity.y += gravity
	$AnimationPlayer.play("fall")

func fall_finished():
	player_state = animation_states.LAND


func land():
	if is_on_floor() && has_jumped:
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
		
		
	
