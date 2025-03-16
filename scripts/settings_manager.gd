extends Node

var fullscreen: bool = false
var language_index: int = 0

func _ready() -> void:
	load_settings()
	apply_settings()
	
func set_fullscreen(enabled: bool):
	fullscreen = enabled
	if enabled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	save_settings()

func set_language(index: int):
	language_index = index
	print("Selected language index: ", index)
	save_settings()

func save_settings():
	var config = ConfigFile.new()
	config.set_value("Settings", "Fullscreen", fullscreen)
	config.set_value("Settings", "Language", language_index)
	config.save("user://settings.cfg")

func load_settings():
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		fullscreen = config.get_value("Settings", "Fullscreen", false)
		language_index = config.get_value("Settings", "Language", 0)

func apply_settings():
	set_fullscreen(fullscreen)
	set_language(language_index)
