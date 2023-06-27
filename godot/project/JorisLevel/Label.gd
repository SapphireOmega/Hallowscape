extends Area2D

func _on_body_entered(_body: CharacterBody2D) -> void:
	for child in get_children():
		create_tween().tween_property(child, "modulate:a", 1, 1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)


