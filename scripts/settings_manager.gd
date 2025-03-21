extends Node

var fullscreen: bool = false
var language: String = "en"
var music_volume: float = 1.0
var sfx_volume: float = 1.0

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

func set_music_volume(value: float):
	music_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))

func set_sfx_volume(value: float):
	sfx_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))

func save_settings():
	var config = ConfigFile.new()
	config.set_value("Settings", "Fullscreen", fullscreen)
	config.set_value("Settings", "Language", language)
	config.set_value("Settings", "MusicVolume", music_volume)
	config.set_value("Settings", "SFXVolume", sfx_volume)
	config.save("user://settings.cfg")

func load_settings():
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		fullscreen = config.get_value("Settings", "Fullscreen", false)
		language = config.get_value("Settings", "Language", "en")
		music_volume = config.get_value("Settings", "MusicVolume", 1.0)
		sfx_volume = config.get_value("Settings", "SFXVolume", 1.0)
	
func apply_settings():
	set_fullscreen(fullscreen)
	set_language(language)
	set_music_volume(music_volume)
	set_sfx_volume(sfx_volume)
