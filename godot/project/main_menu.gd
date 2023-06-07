extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/Start.grab_focus()
	MusicGallery.play_track_by_name("SU_1")
	

func _on_start_button_up():
	MusicGallery.stop_track_by_name("SU_1")
	#add below whatever the start scene is, currently just crashes the game
	get_tree().change_scene("res://main.tscn")




func _on_options_button_up():
	get_tree().quit()


func _on_quit_button_up():
	get_tree().quit()

