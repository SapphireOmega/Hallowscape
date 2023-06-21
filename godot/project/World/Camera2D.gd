extends Camera2D


var shake_amount : float = 0
var default_offset : Vector2 = offset
var pos_x : int #number
var pos_y : int

@onready var timer : Timer = $Timer
@onready var tween : Tween = create_tween()

@export var duration = 0.1
@export var intensity = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().root.ready

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	focus_player_centre()
	offset = Vector2(randf_range(-1, 1) * shake_amount, randf_range(-1, 1) * shake_amount)

func setCamLimits(top, bottom, left, right):
	self.limit_top = top
	self.limit_bottom = bottom
	self.limit_left = left
	self.limit_right = right


var vee : Vector2
func focus_player_centre():
	#TODO find_players() every frame is hyper inefficient, fix ASAP
	var players = StageManager.find_players()
	if len(players) != 0:
		vee = Vector2(0,0)
		for p in players:
			vee += p.position
		vee = vee/len(players)
		self.position = vee


func shake(time: float, amount: float):
	timer.wait_time = time
	shake_amount = amount
	timer.start()



func _on_timer_timeout():
	tween.interpolate_value(self, "offset", 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	shake_amount = 0


func focus_cam_to_pos(pos, i):
	if i == true:
		$Camera2D.enabled = true
		$Camera2D.offset.y = pos.y/3
		self.enabled = false
	else:
		self.enabled = true
		$Camera2D.enabled = false


