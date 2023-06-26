extends CharacterBody2D
var timer = Timer.new()

func _ready():
	add_child(timer)
	timer.connect("timeout", play)
	timer.set_wait_time(1.5)
	timer.one_shot = false
	timer.start()

func play():
	$AnimationPlayer.play("run")
	await get_tree().create_timer(0.5).timeout
	$AnimationPlayer.play("jump")
	await get_tree().create_timer(0.5).timeout
	$AnimationPlayer.play("attack")
