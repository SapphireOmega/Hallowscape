extends Area2D
	

var players = 0

func _on_body_entered(body: CharacterBody2D):
	if body.name == "player" or body.name == "player2":
		players +=1
		if players == 2:
			StageManager.changeStage(StageManager.WIN,0,0, false)
			StageManager.getCam().position = get_viewport_rect().size/2

func _on_body_exited(body: CharacterBody2D):
	if body.name == "player" or body.name == "player2":
		players -=1
