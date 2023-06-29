# This file is used to hide and fade in the second splash screen.
extends Control

@export var _time: float = 2
@export var _fade_time: float = 1

signal finished()

# Sets the initial state of the second splash screen
func start() -> void:
	# hide the splash screen
	modulate.a = 0
	show()
	var tween: Tween = create_tween()
	tween.connect("finished", _finish)
	# fade in the splash screen
	tween.tween_property(self, "modulate:a", 1, _fade_time)
	# show the splash screen for a few seconds dependent on the _time variable
	tween.tween_interval(_time)
	# fade away the splash screen
	tween.tween_property(self, "modulate:a", 0, _fade_time)

# free the node after this splash screen is finished
func _finish() -> void:
	emit_signal("finished")
	queue_free()
