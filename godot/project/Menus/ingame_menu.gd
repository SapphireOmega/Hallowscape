extends CanvasLayer

#the set() function changes the setvalue behaviour of is_paused
#so when is_paused is set to true, the game is paused and the menu's
#visibility is set to true, and vice versa when is_paused is set to true
var is_paused = false : 
	set(value):
		is_paused = value
		get_tree().paused = is_paused
		visible = is_paused

#when esc is pressed and no other function uses that button press that frame
#the pause menu is brought up
#this means that when esc is used for example to quit a dialogue,
#it wont pause the game instead
func _unhandled_input(event):
	var cs = get_tree().current_scene
	var cl = cs.find_child("Current_level")
	if cl.get_child_count() != 0 && cl.get_child(0).name != "Menu":
		if event.is_action_released("ui_cancel"):
			self.is_paused = !is_paused


#resume the game button
func _on_resume_button_up():
	self.is_paused = false


#quit button
func _on_quit_button_up():
	get_tree().quit()
