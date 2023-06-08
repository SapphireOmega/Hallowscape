extends CharacterBody2D

@onready var animation = $AnimationPlayer

@export var speed = 300
@export var gravity = 30
@export var max_vel = 500
@export var jump_force = 600
@export var face_dir = 1

func _physics_process(delta):
	x_movement()
	jumping()
	
	move_and_slide()
	
	
func x_movement():
	#naar links of rechts bewegen
	var hor_dir = Input.get_axis("move_left", "move_right")
	velocity.x = speed * hor_dir
	
	#bij stilstaan idle animation afspelen
	if hor_dir == 0 && is_on_floor():
		$AnimationPlayer.play("idle")
	if hor_dir != 0 && !is_on_floor():
		$AnimationPlayer.play("walk")
		
	#functie zodat poppetje goede kant op kijkt
	set_direction(hor_dir)
	
func set_direction(hor_dir):
	if hor_dir == 0: #niet nodig bij stilstaan
		return
		
	apply_scale(Vector2(hor_dir * face_dir, 1)) # flip
	face_dir= hor_dir # remember direction
	
var landing = false
func jumping():
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			$AnimationPlayer.stop()
			$AnimationPlayer.play("jump")
			landing = true
			velocity.y = -jump_force	
	else: #als in de lucht
		#in de lucht zwaartekracht toegepast
		if velocity.y <= max_vel:
			velocity.y += gravity
		if velocity.y > 0:
			$AnimationPlayer.play("fall")

