extends CanvasLayer

# ---levels-------------- #
#ADD LEVELS TO THIS LIST!
const JORISLEVEL = preload("res://JorisLevel/joris_level.tscn")
const TOWN = preload("res://Town/town.tscn")
const CHURCH = preload("res://Church/church.tscn")
const MAINMENU = preload("res://Menus/main_menu.tscn")
const MAIN = preload("res://main.tscn")
# ---------------------- #


const f6_error_msg = "Stage Manager: Main scene wasn't found, created a Main scene and moved current_scene
		into Main/current_level. Check 'remote' for the exact hierarchy"

# this determines which scene loads on default run
# set to MAINMENU in final build
@export var default_scene = JORISLEVEL

#this fixes the node hierarchy on launch.
func _on_ready():
	var root = get_tree().get_root()
	var last_child = root.get_child(root.get_child_count()-1)
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
	if curStagePath().get_child(0) == null:
		print("Stage Manager: No self-chosen stage found, selecting the default stage instead")
		curStagePath().add_child(default_scene.instantiate())
	adjust_cam_to_stage(curStage())

func curStagePath():
	return $"/root/Main".find_child("Current_level")
	
func curStage():
	return $"/root/Main".find_child("Current_level").get_child(0)


func getCam():
	return $"/root/Main".find_child("Player_data").get_child(0)

func changeStage(stage_path, x=0, y=0):
	$TextureRect.show()
	$Anim.play("TransIn")
	await $Anim.animation_finished
# ----------Do loading stuff here--------- #
	
	var stage = stage_path.instantiate()
	
	if curStagePath().get_child(0) != null:
		curStagePath().get_child(0).free()
	curStagePath().add_child(stage)
	
	
	var players = find_players()
	for player in players:
		move_player_to(player, x, y)
		x+= 15
		player.set_spawn()
	
	fastMoveCam(getCam())
	adjust_cam_to_stage(stage)
# -------------------------------------- #
	$Anim.play("TransOut")
	await $Anim.animation_finished
	$TextureRect.hide()

#grabs a given player and moves him to the provided position
func move_player_to(player, x, y):
	player.position = Vector2(x,y)


func fastMoveCam(cam):
	cam.position_smoothing_enabled = false
	await get_tree().process_frame
	await get_tree().process_frame
	cam.position_smoothing_enabled = true

func find_players():
	var players = []
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


func kill_players():
	$TextureRect2.show()
	$Anim.play("DeathIn")
	await $Anim.animation_finished
	
	var players = find_players()
	for player in players:
		player.die()
	fastMoveCam(getCam())
	
	
	$Anim.play("DeathOut")
	await $Anim.animation_finished
	$TextureRect2.hide()


