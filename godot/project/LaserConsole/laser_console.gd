extends Area2D

@export var laser_names = ["Laser"]  # Will look for this laser in the tree and disable it

var can_interact = []  # All CharacterBody2Ds that are at the console

var puzzle_solved: bool = false
var lever_down: bool = false

#var puzzles = ["tap", "holes", "shapeSequence", "memory", "lock", "coin"]
var puzzles = ["shapeSequence"]

func _on_body_entered(body: CharacterBody2D) -> void:
	can_interact.append(body)

func _on_body_exited(body: CharacterBody2D) -> void:
	can_interact.erase(body)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)


func when_puzzle_solved():
	puzzle_solved = true
	$Sprite2D.region_rect.position.x += 50
	laser()
	
	
func laser():
	for laser_name in laser_names:
		var laser: Object = self.get_parent().get_node(laser_name)
		laser.set_is_casting(!laser.get_is_casting())	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	for body in can_interact.filter(func(body): return body.has_method("get_input") && body.is_on_floor()):
		if !body.get_input()["interact"]: return
		Input.action_release("interact"+str(body.player_id))
		
		if !puzzle_solved:
			var randomPuzzle = puzzles[randi() % puzzles.size()]
			var server = $"/root/Server"
			if server: server.sendPuzzle(body.player_id, randomPuzzle, self.get_instance_id())
			if !server || !server.RunOnLaunch: when_puzzle_solved()
		else:
			$Sprite2D.region_rect.position.x += (1 if lever_down else -1) * 25
			lever_down = !lever_down
			laser()

