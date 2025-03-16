extends Node

var fullscreen: bool = false
var language: String = "en"

func _ready() -> void:
	load_settings()
	apply_settings()
	
func set_fullscreen(enabled: bool):
	fullscreen = enabled
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN if enabled else DisplayServer.WINDOW_MODE_WINDOWED
	)
	save_settings()

func set_language(lang: String):
	language = lang
	save_settings()

func save_settings():
	var config = ConfigFile.new()
	config.set_value("Settings", "Fullscreen", fullscreen)
	config.set_value("Settings", "Language", language)
	config.save("user://settings.cfg")

func load_settings():
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		fullscreen = config.get_value("Settings", "Fullscreen", false)
		language = config.get_value("Settings", "Language", "en")
	
func apply_settings():
	set_fullscreen(fullscreen)
	set_language(language)
