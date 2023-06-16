extends Control

# TODO: make this scene the launch scene
# untill then please use f6 to start the main menu
# its already setup to switch scenes to the main scene
# use get_tree().change_scene_to_file() to change scenes between main
# menu and other scenes, should work in reverse too in theory

func _ready():
	$VBoxContainer/Start.grab_focus() #selects the start button so you can start with enter
	MusicGallery.play_track_by_name("pengel") #main menu theme


#stops playing the main menu theme, then switches to the main scene
func _on_start_button_up():
	MusicGallery.stop_track_by_name("pengel")
	#add below whatever the start scene is
	StageManager.changeStage(StageManager.TOWN, 50, 312)




#TODO: make options menu
func _on_options_button_up():
	pass

#quits the game
func _on_quit_button_up():
	get_tree().quit()
