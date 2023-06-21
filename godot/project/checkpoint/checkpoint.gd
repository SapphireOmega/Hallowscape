extends Area2D



func _on_body_entered(body):
	if body.has_method("set_spawn"):
		print("checkpoint")
		var i = 0
		for player in StageManager.find_players():
			player.set_spawn(self.position + Vector2(i, 0))
			i+=17

