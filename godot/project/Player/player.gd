extends CharacterBody2D

@export var speed = 150
@export var gravity = 30
@export var jump_force = 500
@export var max_jump_force = 3000
@export var face_dir = 1

var player_state = animation_states.MOVE
enum animation_states {MOVE, ATTACK, JUMP, FALL, LAND}

var has_jumped = false
var has_double_jumped = false
var can_jump = false
var coyote_timer = 0


func _physics_process(delta):
	timer(delta)
	velocity.y += gravity
	
	if is_on_floor():
		velocity.y = 0
		coyote_timer = 0.2
		can_jump = true

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
	
func movement():
	var movement = Input.get_axis("move_left", "move_right")
	velocity.x = speed * movement
	set_direction(movement)
	
func move():
	var movement = Input.get_axis("move_left", "move_right")
#	velocity.x = speed * movement
#
#	set_direction(movement)
	movement()
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
#	var movement = Input.get_axis("move_left", "move_right")
#	velocity.x = speed * movement
#	set_direction(movement)
	movement()
	$AnimationPlayer.play("jump")
#
	if coyote_timer > 0 && can_jump:
		if !is_on_floor():
			can_jump = false

		velocity.y = -jump_force
		coyote_timer = 0.2
		
	if Input.is_action_just_pressed("jump") && !can_jump && coyote_timer > 0:
		movement()
		velocity.y = -jump_force
	
	if velocity.y > 0:
		player_state = animation_states.FALL


func jump_finished():
	print("falling in 2")
	player_state = animation_states.FALL


func fall():
	movement()
	$AnimationPlayer.play("fall")

func fall_finished():
	player_state = animation_states.LAND


func land():
	if is_on_floor() && has_jumped:
		has_jumped = false
		can_jump = true
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
		
	
func timer(delta):
	coyote_timer -= delta
		
		
	
#func jump():
#	var movement = Input.get_axis("move_left", "move_right")
#	velocity.x = speed * movement
#	$AnimationPlayer.play("jump")
##	if can_jump && is_on_floor():
#		if velocity.y > -max_jump_force:
#			velocity.y = -jump_force
#		has_jumped = true
#	elif has_jumped && !has_double_jumped && !is_on_floor():
#		if Input.is_action_just_pressed("jump"):
#			print("in double jump")
#			velocity.y = -jump_force
#			has_double_jumped = true
#
#	set_direction(movement)
#
#	if velocity.y > 0:
#		player_state = animation_states.FALL

# op grond staat, double jumpen
# can jump false als je 





#if can_jump == true && !can_double_jump:
#			print("mag springen")
#			if velocity.y > -max_jump_force:
#				velocity.y = -jump_force
#			can_jump = false
#		if !can_jump && can_double_jump:
#			if velocity.y > -max_jump_force:
#				velocity.y = -jump_force
#			can_double_jump = false
