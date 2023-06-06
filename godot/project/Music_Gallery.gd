extends Node


var queue : int = 0
var index : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#$Core/SU_4.play()
	#$Core/SU_5.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_up") == true:
		queue += 1






func _on_timer_timeout() ->void:
	if queue > 0:
		play_random_track($Random)
		queue -= 1



#plays a random track from the given node
func play_random_track(node):
	var playable = []
	for track in node.get_children():
		if not track.is_playing():
			playable.append(track)
	if playable.size() == 0:
		return
	index = randi() % playable.size()
	playable[index].play()
	

