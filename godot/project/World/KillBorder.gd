#Script for killing the players when players are too far apart horizontally

extends Area2D


func _ready():
	monitoring = true
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Kill both players when a player interacts with the bottom screen hitbox
	if body.has_method("push_barrels"):
		StageManager.kill_players(body.player_id)

