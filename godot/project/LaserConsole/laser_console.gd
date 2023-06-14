extends Area2D

@export var laser_name: String = "Laser"  # Will look for this laser in the tree and disable it

var can_interact = []  # All CharacterBody2Ds that are at the console

func _on_body_entered(body: CharacterBody2D) -> void:
	can_interact.append(body)

func _on_body_exited(body: CharacterBody2D) -> void:
	can_interact.erase(body)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func update_laser_if_interacted(body: CharacterBody2D) -> void:
	if !body.get_input()["interact"]: return
	var laser: Object = self.get_parent().get_node(laser_name)
	laser.set_is_casting(!laser.get_is_casting())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	can_interact.map(update_laser_if_interacted)
