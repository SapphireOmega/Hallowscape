extends Area2D

func _on_body_entered(_body) -> void:
	create_tween().tween_property($Label, "modulate:a", 1, 1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)


