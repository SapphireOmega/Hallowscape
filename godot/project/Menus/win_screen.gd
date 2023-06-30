extends Control




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	StageManager.getCam().position_smoothing_enabled = false
	StageManager.getCam().position = get_viewport_rect().size/2
