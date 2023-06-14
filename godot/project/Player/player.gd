extends CharacterBody2D

# BASIC MOVEMENT VARAIABLES ---------------- #
var face_direction := 1
var x_dir := 1

@export var max_speed: float = 135
@export var acceleration: float = 1440
@export var turning_acceleration : float = 3600
@export var deceleration: float = 2200
# ------------------------------------------ #

# GRAVITY ----- #
@export var gravity_acceleration : float = 1100
@export var gravity_max : float = 400
# ------------- #

# animations ----- #
@export var land_anim_length : float = 0.05
var land_timer : float = 0
# ------------- #g

# JUMP VARAIABLES ------------------- #
@export var jump_force : float = 330
@export var jump_cut : float = 0.25
@export var jump_gravity_max : float = 150
@export var jump_hang_treshold : float = 2.0
@export var jump_hang_gravity_mult : float = 0.10
# Timers
@export var jump_coyote : float = 0.12
@export var jump_buffer : float = 0.14

var jump_coyote_timer : float = 0
var jump_buffer_timer : float = 0
var is_jumping := false
var is_double_jumping := false
var double_jump_bypass := false
# ----------------------------------- #
var spawn_point: Vector2

func _ready() -> void:
	spawn_point = self.position
	
func die() -> void:
	self.position = spawn_point

# All iputs we want to keep track of
func get_input() -> Dictionary:
	return {
		"x": Input.get_axis("move_left", "move_right"),
		"y": Input.get_axis("ui_down", "ui_up"),
		"just_jump": Input.is_action_just_pressed("jump") == true,
		"jump": Input.is_action_pressed("jump") == true,
		"released_jump": Input.is_action_just_released("jump") == true,
		"just_attack": Input.is_action_just_pressed("attack") == true,
		"attack": Input.is_action_just_pressed("attack") == true,
		"interact": Input.is_action_just_pressed("interact") == true
	}


func _physics_process(delta: float) -> void:
	x_movement(delta)
	double_jump_logic(delta)
	jump_logic(delta)
	apply_gravity(delta)
	
	timers(delta)
	move_and_slide()
	if self.is_on_floor: push_barrels(delta)
	update_animation()

func push_barrels(delta: float) -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var angle = collision.get_angle()
		var obj: Object = collision.get_collider()
		if obj.has_method("slide") && (angle > 1.569 && angle < 1.571):
			print(angle)
			obj.slide(delta, 100 * face_direction)

func x_movement(delta: float) -> void:
	x_dir = get_input()["x"]

	if x_dir == 0: # Stop if we're not doing movement inputs.
		velocity.x = Vector2(velocity.x, 0).move_toward(Vector2(0,0), deceleration * delta).x
		return
	
	# If we are doing movement inputs and above max speed, don't accelerate nor decelerate
	# Except if we are turning
	# (This keeps our momentum gained from outside or slopes)
	if abs(velocity.x) >= max_speed and sign(velocity.x) == x_dir:
		return
	
	# Are we turning?
	# Deciding between acceleration and turn_acceleration
	var accel_rate : float = acceleration if sign(velocity.x) == x_dir else turning_acceleration
	
	# Accelerate
	velocity.x += x_dir * accel_rate * delta
	
	set_direction(x_dir) # This is purely for visuals


func set_direction(hor_direction) -> void:
	# This is purely for visuals
	# Turning relies on the scale of the player
	# To animate, only scale the sprite
	if hor_direction == 0:
		return
	apply_scale(Vector2(hor_direction * face_direction, 1)) # flip
	face_direction = hor_direction # remember direction


func jump_logic(_delta: float) -> void:
	# Reset our jump requirements
	if is_on_floor():
		jump_coyote_timer = jump_coyote
		if is_jumping == true:
			is_jumping = false
			if !$AnimationPlayer.current_animation == "attack":
				$AnimationPlayer.play("land")
				land_timer = land_anim_length
	if get_input()["just_jump"]:
		jump_buffer_timer = jump_buffer
	
	# Jump if grounded, there is jump input, and we aren't jumping already
	if jump_coyote_timer > 0 and jump_buffer_timer > 0:
		if !is_jumping:
			is_jumping = true
			jump_coyote_timer = 0
			jump_buffer_timer = 0
			velocity.y = -jump_force
	
	# Cut the velocity if let go of jump. This means our jumpheight is varaiable
	# This should only happen when moving upwards, as doing this while falling would lead to
	# The ability to studder our player mid falling
	if get_input()["released_jump"] and velocity.y < 0:
		velocity.y -= (jump_cut * velocity.y)
	
	# This way we won't start slowly descending / floating once hit a ceiling
	# The value added to the treshold is arbritary,
	# But it solves a problem where jumping into 
	if is_on_ceiling(): velocity.y = jump_hang_treshold + 10.0
	if is_on_ceiling(): print("test") 


func double_jump_logic(_delta: float) -> void:
	if is_on_floor():
		is_double_jumping = false
		double_jump_bypass = false
	if jump_coyote_timer <= 0 and !is_jumping:
		double_jump_bypass = true

	if get_input()["just_jump"] && (is_jumping or double_jump_bypass) && !is_double_jumping:
		is_double_jumping = true
		velocity.y = -jump_force*0.9


func apply_gravity(delta: float) -> void:
	var applied_gravity : float = 0
	
	# No gravity if we are grounded
	if is_on_floor() == true:
		return
	
	# Normal gravity limit
	if velocity.y <= gravity_max:
		applied_gravity = gravity_acceleration * delta
	
	# If moving upwards while jumping, the limit is jump_gravity_max to achieve lower gravity
	if (is_jumping and velocity.y < 0) and velocity.y > jump_gravity_max:
		applied_gravity = 0
	
	# Lower the gravity at the peak of our jump (where velocity is the smallest)
	if is_jumping and abs(velocity.y) < jump_hang_treshold:
		applied_gravity *= jump_hang_gravity_mult
	
	velocity.y += applied_gravity


func timers(delta: float) -> void:
	# Using timer nodes here would mean unnecessary functions and node calls
	# This way everything is contained in just 1 script with no node requirements
	if jump_coyote_timer >= 0:
		jump_coyote_timer -= delta
	if jump_buffer_timer >= 0:
		jump_buffer_timer -= delta
	if land_timer >= 0:
		land_timer -= delta




func update_animation():
	if get_input()["attack"] == true or $AnimationPlayer.current_animation == "attack":
		if !$AnimationPlayer.current_animation == "just_attack":
			$Area2D/CollisionShape2D.disabled = false
			$AnimationPlayer.play("attack")
	else:
		$Area2D/CollisionShape2D.disabled = true
		if is_jumping == true:
			if velocity.y < 0:
				$AnimationPlayer.play("jump")
			else:
				$AnimationPlayer.play("fall")
		else:
			#this is the lowest priority
			if $AnimationPlayer.current_animation == "land" && 	land_timer > 0:
				pass
			else:
				#this is the lowest priority
				if get_input()["x"] != 0:
					$AnimationPlayer.play("run")
				else:
					$AnimationPlayer.play("idle")





#------------ interactables --- #

func _player_detected(body: Area2D):
	var t = Timer.new()
	# Waits for exact frame where the player hits.
	t.set_wait_time(0.2)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	await t.timeout

	if body.is_in_group("hit"):
		body.take_damage()
	else:
		pass




	
