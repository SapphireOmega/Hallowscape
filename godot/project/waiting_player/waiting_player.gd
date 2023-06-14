extends Node2D

@export var num_player = 0
var max_player = 2
# Called when the node enters the scene tree for the first time.

func _ready():
	pass
	

@rpc
func set_players(num):
	num_player = num
	$Label.text = str(num_player)+"/"+str(max_player)
	var pos = get_viewport_rect().size/2
	$Label.set_position(pos)
	
