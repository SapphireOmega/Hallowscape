extends Camera2D


var vee : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().root.ready


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#TODO find_players() every frame is hyper inefficient, fix ASAP
	var players = StageManager.find_players()
	if len(players) != 0:
		vee = Vector2(0,0)
		for p in players:
			vee += p.position
		vee = vee/len(players)
		print(vee)
		self.position = vee

func setCamLimits(top, bottom, left, right):
	self.limit_top = top
	self.limit_bottom = bottom
	self.limit_left = left
	self.limit_right = right



