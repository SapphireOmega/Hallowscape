extends CanvasLayer

# ---levels-------------- #
#ADD LEVELS TO THIS LIST!
const JORISLEVEL = preload("res://JorisLevel/joris_level.tscn")
const JORISLEVEL2 = preload("res://JorisLevel2/joris_level2.tscn")
const TOWN = preload("res://Town/town.tscn")
const CHURCH = preload("res://Church/church.tscn")
const MAINMENU = preload("res://Menus/main_menu.tscn")
const MAIN = preload("res://main.tscn")
const WIN = preload("res://Menus/win_screen.tscn")
# ---------------------- #

# ---GLOBALS------------- #
@onready var players_at_npc = 0
@export var max_hp = 5
@onready var health1 = 5

const f6_error_msg = "Stage Manager: Main scene wasn't found, created a Main scene and moved current_scene
		into Main/current_level. Check 'remote' for the exact hierarchy"

# this determines which scene loads on default run
# set to MAINMENU in final build
@export var default_scene = JORISLEVEL

#this fixes the node hierarchy on launch.
func _on_ready():
	DisplayServer.window_set_min_size(Vector2(640, 360))
	var root = get_tree().get_root()
	var last_child = root.get_child(root.get_child_count()-1)
	swap_fullscreen_mode()
	await root.ready
	if last_child.name != "Main" && last_child.name != self.name:
		var newstage = MAIN.instantiate()
		root.add_child(newstage)
		get_tree().current_scene = newstage
		root.remove_child(last_child)
		get_tree().current_scene.find_child("Current_level").add_child(last_child)
		print(f6_error_msg)
	elif last_child.name == self.name:
		self.queue_free()
	if curStagePath().get_child_count() == 0:
		print("Stage Manager: No self-chosen stage found, selecting the default stage instead")
		curStagePath().add_child(default_scene.instantiate())
	adjust_cam_to_stage(curStage())

func curStagePath():
	return $"/root/Main".find_child("Current_level")


func curServer():
	return $"/root/Main".find_child("Server")

func swap_fullscreen_mode():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)



func curStage():
	if $"/root/Main".find_child("Current_level").get_child_count() == 0:
		return null
	return $"/root/Main".find_child("Current_level").get_child(0)


func getCam():
	return $"/root/Main".find_child("Player_data").get_child(0)

func changeStage(stage_path, x=0, y=0, with_screen = true):
	if with_screen:
		$TextureRect.modulate.a = 0
		$TextureRect.show()
		$Anim.play("TransIn")
		await $Anim.animation_finished
# ----------Do loading stuff here--------- #
	StageManager.hide_hp()
	var stage = stage_path.instantiate()
	var oldstage = curStagePath().get_child(0)
	
	if curStagePath().get_child_count() > 0 and curStagePath().get_child_count() != 0:
		curStagePath().remove_child(oldstage)
		oldstage.queue_free()
	curStagePath().add_child(stage)
	
	var players = find_players()
	for player in players:
		move_player_to(player, x, y)
		x+= 15
		#player.set_spawn()
	health1 = max_hp
	set_hp(5)
	fastMoveCam(getCam())
	adjust_cam_to_stage(stage)
# -------------------------------------- #
	if with_screen:
		$Anim.play("TransOut")
		await $Anim.animation_finished
		$TextureRect.hide()

#grabs a given player and moves him to the provided position
func move_player_to(player, x, y):
	player.position = Vector2(x,y)
	print(player.position)


func fastMoveCam(cam):
	cam.position_smoothing_enabled = false
	await get_tree().process_frame
	await get_tree().process_frame
	cam.position_smoothing_enabled = true

func find_players():
	var players = []
	if curStagePath().get_child_count() > 0:
		var stage = curStagePath().get_child(0)
		if stage != null:
			for node in stage.get_children():
				if node.has_method("set_spawn"):
					players.append(node)
			return players
	return []



func adjust_cam_to_stage(stage):
	if stage.get("CAMLIMITS"):
		var cl = stage.CAMLIMITS
		getCam().setCamLimits(cl["top"], cl["bottom"], cl["left"], cl["right"])





var is_killing = false
func kill_players(player_id):
	var players = find_players()
	for player in players:
		player.dead = true
		if player.player_id == player_id:
			player.get_child(4).play("die")
	await get_tree().create_timer(0.8).timeout
	
	$TextureRect2.modulate.a = 0
	$TextureRect2.show()
	$Anim.play("DeathIn")
	await $Anim.animation_finished
	################
	for player in players:
		player.die()
		player.dead = false
	fastMoveCam(getCam())
	health1 = max_hp
	set_hp(5)
	#################
	$Anim.play("DeathOut") 
	await $Anim.animation_finished
	$TextureRect2.hide()
	is_killing = false


func dialcam():
	if DialogueManager.npc1:
		if DialogueManager.conversing:
			var curr = curStage()
			if curr.has_node("npc1"):
				var cam = curr.get_node("npc1").get_node("dialogue_cam")
				cam.enabled = true
		else:
			var curr = curStage()
			if curr.has_node("npc1"):
				var cam = curr.get_node("npc1").get_node("dialogue_cam")
				cam.enabled = false
	elif DialogueManager.npc2:
		if DialogueManager.conversing:
			var curr = curStage()
			if curr.has_node("npc2"):
				var cam = curr.get_node("npc2").get_node("dialogue_cam")
				cam.enabled = true
		else:
			var curr = curStage()
			if curr.has_node("npc2"):
				var cam = curr.get_node("npc2").get_node("dialogue_cam")
				cam.enabled = false


func set_hp(desired_amount):
	$GUI.set_hp(desired_amount)

func minus_hp():
	$GUI.minus_hp()

func add_hp():
	$GUI.add_hp()

func hide_hp():
	$GUI.hide_hp()

func show_hp():
	$GUI.show_hp()



