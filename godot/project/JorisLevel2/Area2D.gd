extends Area2D



func _on_body_entered(body):
	StageManager.changeStage(StageManager.JORISLEVEL, 1920, 270)
