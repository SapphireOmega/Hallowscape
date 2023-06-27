extends Control

@export var _time: float = 2
@export var _fade_time: float = 1
var timer = Timer.new()

signal finished()


func start() -> void:
	modulate.a = 0
	show()
	add_child(timer)
	timer.connect("timeout", play)
	timer.set_wait_time(1.5)
	timer.one_shot = false
	var tween: Tween = create_tween()
	tween.connect("finished", _finish)
	tween.tween_property(self, "modulate:a", 1, _fade_time)
	timer.start()
	tween.tween_interval(_time)
	tween.tween_property(self, "modulate:a", 0, _fade_time)

func _finish() -> void:
	emit_signal("finished")
	queue_free()

func play():
	$player1/AnimationPlayer.play("run")
	$player2/AnimationPlayer.play("run")
	await get_tree().create_timer(0.5).timeout
	$player1/AnimationPlayer.play("jump")
	$player2/AnimationPlayer.play("jump")
	await get_tree().create_timer(0.5).timeout
	$player1/AnimationPlayer.play("attack")
	$player2/AnimationPlayer.play("attack")
