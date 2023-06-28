# This file is responsible for managing splash screens that appear at the beginning.

extends Control


@export var _initial_delay: float = 1

var _splash_screens = []

@onready var _splash_screen_container = $screen

# In this function, the script initializes the necessary variables and prepares the splash screens 
# for display. It also plays a track named "pengel" using a "MusicGallery" object and creates a 
# timer with an initial delay. After that, it calls the _start_splash_screen() function to begin 
# displaying the splash screens.
func _ready() -> void:
	set_process_input(false)

	for splash_screen in _splash_screen_container.get_children():
		splash_screen.hide()
		_splash_screens.push_back(splash_screen)
	MusicGallery.play_track_by_name("pengel")
	await get_tree().create_timer(_initial_delay).timeout
	_start_splash_screen()

	set_process_input(true)

# if the left mouse button or bar is pressed. The current splash screen will be skipped.
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_skip"):
		_skip()

# This function is responsible for starting the splash screens. It checks if there are any remaining
# splash screens in the _splash_screens array. If there are no more splash screens, it means all the
# screens have been shown, so the function calls queue_free() to remove the current node.
func _start_splash_screen() -> void:
	if _splash_screens.size() == 0:
		queue_free()
		StageManager.changeStage(StageManager.MAINMENU,0,0,false)
	else:
		var splash_screen = _splash_screens.pop_front()
		splash_screen.start()
		splash_screen.connect("finished", _start_splash_screen)

# Skip the current splash screen and display the next splash screen.
func _skip() -> void:
	_splash_screen_container.get_child(0).queue_free()
	_start_splash_screen()
