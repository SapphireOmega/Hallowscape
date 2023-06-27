extends CharacterBody2D

const speed = 60
var accel = 0.07
var dir
var face_direction := 1
var in_range = false

@export var player: CharacterBody2D
@onready var nav_ag := $NavigationAgent2D as NavigationAgent2D
@onready var spawn = self.position

func _ready():
	$Attack_player.visible = false
	$Attack_player.monitoring = false
	$AttackSprite.visible = false
	$IdleSprite.visible = true
	$AnimationPlayer.play("idle")
	makepath()

func _physics_process(delta) -> void:
	makepath()
	dir = nav_ag.get_next_path_position() - global_position
	velocity = dir.normalized() * speed
	move_and_slide()


func makepath() -> void:
	if player.position.distance_to(spawn) > 200:
		nav_ag.target_position = spawn
	elif player.position.distance_to(nav_ag.target_position) < 20:
		pass
	else:
		nav_ag.target_position = player.position


func player_attack(body: CharacterBody2D):
	if $Attack_player.monitoring and body.is_in_group("player"):
		body.take_damage()


func _on_detectplayer_body_entered(body):
	if body.is_in_group("player"):
		$Attack_player.monitoring = true
		$Attack_player.visible = true
		in_range = true


func _on_detectplayer_body_exited(body):
	if body.is_in_group("player"):
		$Attack_player.monitoring = false
		$Attack_player.visible = false
		in_range = false


#func _on_animation_player_animation_finished(anim_name):
#	if in_range == false:
#		$Attack_player.visible = false
#		$AttackSprite.visible = false
#		$IdleSprite.visible = true
#		animation.queue("idle")
