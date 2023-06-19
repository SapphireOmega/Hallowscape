extends Area2D
	



func _on_body_entered(body: CharacterBody2D):
	StageManager.changeStage(StageManager.JORISLEVEL, 1960, 220)
	


