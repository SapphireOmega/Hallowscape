extends Camera2D

var players

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	players = StageManager.find_players()
	if len(players) > 0:
		self.offset.x = -players[0].position.x
