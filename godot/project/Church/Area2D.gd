extends Area2D
	



func _on_body_entered(body: CharacterBody2D):
	StageManager.changeStage(StageManager.TOWN, 1960, 250)
	


