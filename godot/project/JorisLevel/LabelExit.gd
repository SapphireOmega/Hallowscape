### Make message less visible when player continues on.

extends Area2D

func _on_body_entered(body) -> void:
	if !body.has_method("die"): return
	for child in get_parent().get_children():
		create_tween().tween_property(child, "modulate:a", 0.3, 1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)
	
