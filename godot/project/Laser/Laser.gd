extends RayCast2D

@export var is_casting = true : set = set_is_casting, get = get_is_casting

func set_is_casting(x: bool) -> void:
	is_casting = x
	
func get_is_casting() -> bool:
	return is_casting

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	force_raycast_update()
	$Line2D.points[1] = Vector2.ZERO     if !is_casting \
				   else Vector2(1000, 0) if !is_colliding() \
				   else to_local(get_collision_point())
	if is_casting && is_colliding():
		var collider = get_collider()
		if collider.has_method("die"):
			if StageManager.is_killing == false:
				StageManager.is_killing = true
				StageManager.kill_players()




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
