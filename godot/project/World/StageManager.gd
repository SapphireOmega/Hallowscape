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
	if $"/root/Main".find_child("Current_level").get_child(0) == null:
		print("rip no stage found")
		$"/root/Main".find_child("Current_level").add_child(default_scene.instantiate())


func changeStage(stage_path, x=0, y=0):
	$ColorRect.show()
	$Loadingtext.show()
	$Anim.play("TransIn")
	await $Anim.animation_finished
	
	
	var stage = stage_path.instantiate()
	
	if $"/root/Main".find_child("Current_level").get_child(0) != null:
		$"/root/Main".find_child("Current_level").get_child(0).free()
	$"/root/Main".find_child("Current_level").add_child(stage)
	
	
	var player = stage.get_node_or_null("player")
	if player != null:
		move_player_to(player, x, y)
	
	
	$Anim.play("TransOut")
	await $Anim.animation_finished
	$ColorRect.hide()
	$Loadingtext.hide()


func move_player_to(player, x, y):
	player.position = Vector2(x,y)
	var cam = player.get_node("Camera2D")
	cam.position_smoothing_enabled = false
	await get_tree().process_frame
	await get_tree().process_frame
	cam.position_smoothing_enabled = true



func hideGui():
	$GUI.hide()
func showGui():
	$GUI.show()

