extends Control

# TODO: make this scene the launch scene
# untill then please use f6 to start the main menu
# its already setup to switch scenes to the main scene

func _ready():
	$Menu/VBoxContainer/Start.grab_focus() #selects the start button so you can start with enter
	MusicGallery.play_track_by_name("pengel")

func _on_credits_button_up():
	$Menu.hide()
	$Credits.show()


#quits the game
func _on_quit_button_up():
	get_tree().quit()




func _on_start_button_up():
	MusicGallery.stop_track_by_name("pengel")
	#add below whatever the start scene is
	
	StageManager.changeStage(StageManager.JORISLEVEL, 50, 312)
	var server = preload("res://TestServerClients/Server.tscn").instantiate()
	$"/root".add_child(server)
#	$"/root/".move_child(server,0)
