extends CharacterBody2D

@export var hitpoints = 3
var hits_taken = 0
@export var gravity = 10
var speed = 32
@onready var Animationtree : AnimationTree = $AnimationTree

func _ready():
	Animationtree.active = true
	$Attack_player.visible = false
	$Attack_player.monitoring = false
	$AttackSprite.visible = false
	$IdleSprite.visible = true
	Animationtree["parameters/conditions/idle"] = true
	
	velocity.x = 0
	velocity.y = gravity
	

func _physics_process(_delta):
	move_and_slide()

func take_damage():
	## hit animation ##
	hits_taken += 1
	print("hit taken")
	if hitpoints == hits_taken:
		print("died")
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

func body_enter_attack(body: CharacterBody2D):
	$AttackSprite.visible = true
	$IdleSprite.visible = false
	Animationtree["parameters/conditions/idle"] = false
	Animationtree["parameters/conditions/body_entered"] = true

func body_out_of_range(body: CharacterBody2D):
	$Attack_player.visible = false
	$AttackSprite.visible = false
	$IdleSprite.visible = true
	Animationtree["parameters/conditions/idle"] = true
	Animationtree["parameters/conditions/body_entered"] = false

func damage_player(body: CharacterBody2D):
	if $Attack_player.monitoring == true:
		print("player hit")

func follow_left():
	pass
