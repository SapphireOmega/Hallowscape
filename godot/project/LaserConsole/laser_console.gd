### Detect if player presses ineract on a laser console. Send a random puzzle
### to the app of said player, wait till the player completes the puzzle,
### flip all lasers in `laser_names`, and mark console as having the puzzle
### completed, so you can flip it as you please without having to redo the
### puzzle after the first time.

extends Area2D

@export var laser_names = ["Laser"]  # Will look for this laser in the tree and disable it

var can_interact = []  # All CharacterBody2Ds that are at the console
var puzzle_solved: bool = false
var lever_down: bool = false
var puzzles = ["tap", "holes", "shapeSequence", "memory", "lock", "coin"]

func _on_body_entered(body) -> void:
	can_interact.append(body)

func _on_body_exited(body) -> void:
	can_interact.erase(body)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func flip_lasers():
	for laser_name in laser_names:
		var l: Object = self.get_parent().get_node(laser_name)
		l.set_is_casting(!l.get_is_casting())	

# Needs to be a function so it can be run by the server after completing a
# puzzle (we can't wait for a response in a loop, since this freezes up the
# physics thread).
func when_puzzle_solved():
	puzzle_solved = true
	$Sprite2D.region_rect.position.x += 50
	flip_lasers()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	for body in can_interact.filter(func(b):
			return b.has_method("get_input") && b.is_on_floor() && b.get_input()["interact"]):
		Input.action_release("interact"+str(body.player_id))
		if !puzzle_solved:
			var server = $"/root/Server"
			if server: server.sendPuzzle(body.player_id, puzzles[randi() % puzzles.size()], self.get_instance_id())
			if !server || !server.RunOnLaunch: when_puzzle_solved()  # Skip puzzle for debugging purposes
		else:
			$Sprite2D.region_rect.position.x += (1 if lever_down else -1) * 25
			lever_down = !lever_down
			flip_lasers()

