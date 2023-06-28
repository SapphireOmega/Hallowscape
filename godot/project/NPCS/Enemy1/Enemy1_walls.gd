# This file is for creating walls where enemy1 will turn around.

extends Area2D

func _on_body_entered(body):
	if body.has_method('change_state'):
		body.change_state()
