extends Area2D
	



func _on_body_entered(_body: CharacterBody2D):
	StageManager.changeStage(StageManager.JORISLEVEL2, 1900, 120)
	


