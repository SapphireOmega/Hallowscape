extends TextureRect

var timer = Timer.new()

func _ready():
	add_child(timer)
	timer.connect("timeout", play)
	timer.set_wait_time(1.5)
	timer.one_shot = false
	timer.start()

func play():
	$player1/AnimationPlayer.play("run")
	$player2/AnimationPlayer.play("run")
	await get_tree().create_timer(0.5).timeout
	$player1/AnimationPlayer.play("jump")
	$player2/AnimationPlayer.play("jump")
	await get_tree().create_timer(0.5).timeout
	$player1/AnimationPlayer.play("attack")
	$player2/AnimationPlayer.play("attack")
