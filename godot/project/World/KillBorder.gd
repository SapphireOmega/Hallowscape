extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	monitoring = true
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.has_method("push_barrels"):
		StageManager.kill_players(body.player_id)
# Called every frame. 'delta' is the elapsed time since the previous frame.

