extends Control


@export var _initial_delay: float = 1

var _splash_screens = []

@onready var _splash_screen_container = $screen


func _ready() -> void:
	set_process_input(false)

	for splash_screen in _splash_screen_container.get_children():
		splash_screen.hide()
		_splash_screens.push_back(splash_screen)
	MusicGallery.play_track_by_name("pengel")
	await get_tree().create_timer(_initial_delay).timeout
	_start_splash_screen()

	set_process_input(true)


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_skip"):
		_skip()

func _start_splash_screen() -> void:
	if _splash_screens.size() == 0:
		StageManager.changeStage(StageManager.MAINMENU)
		
	else:
		var splash_screen = _splash_screens.pop_front()
		splash_screen.start()
		splash_screen.connect("finished", _start_splash_screen)


func _skip() -> void:
	_splash_screen_container.get_child(0).queue_free()
	_start_splash_screen()