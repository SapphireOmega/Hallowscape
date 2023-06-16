extends Area2D

@export var laser_names = ["Laser"]  # Will look for this laser in the tree and disable it

var can_interact = []  # All CharacterBody2Ds that are at the console

func _on_body_entered(body: CharacterBody2D) -> void:
	can_interact.append(body)

func _on_body_exited(body: CharacterBody2D) -> void:
	can_interact.erase(body)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	for body in can_interact:
		if !body.get_input()["interact"]: return
		for laser_name in laser_names:
			var laser: Object = self.get_parent().get_node(laser_name)
			laser.set_is_casting(!laser.get_is_casting())