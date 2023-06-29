# This file is used to hide and fade in the first splash screen.
extends Control

@export var _time: float = 2
@export var _fade_time: float = 1
var timer = Timer.new()

signal finished()

# Sets the initial state of the first splash screen
func start() -> void:
	# hide the splash screen
	modulate.a = 0
	show()
	# add the timer as a child node
	add_child(timer)
	# connect timer to the play function
	timer.connect("timeout", play)
	timer.set_wait_time(1.5)
	timer.one_shot = false
	var tween: Tween = create_tween()
	tween.connect("finished", _finish)
	# fade in the splash screen
	tween.tween_property(self, "modulate:a", 1, _fade_time)
	# start playing character animation
	timer.start()
	# show the splash screen for a few seconds dependent on the _time variable
	tween.tween_interval(_time)
	# fade away the splash screen
	tween.tween_property(self, "modulate:a", 0, _fade_time)

# free the node after this splash screen is finished
func _finish() -> void:
	emit_signal("finished")
	queue_free()

# play character animations
func play():
	$player1/AnimationPlayer.play("run")
	$player2/AnimationPlayer.play("run")
	await get_tree().create_timer(0.5).timeout
	$player1/AnimationPlayer.play("jump")
	$player2/AnimationPlayer.play("jump")
	await get_tree().create_timer(0.5).timeout
	$player1/AnimationPlayer.play("attack")
	$player2/AnimationPlayer.play("attack")
