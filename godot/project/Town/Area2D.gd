extends Area2D
	



func _on_body_entered(body: CharacterBody2D):
	if body.name == "player" or body.name == "player2":
		StageManager.changeStage(StageManager.CHURCH, 25, 310)
	




