extends Control

@onready var logo: TextureRect = $Logo
@onready var tween = get_tree().create_tween()
@onready var main_menu: VBoxContainer = $ButtonsControl/VBoxButtons
@onready var level_menu: VBoxContainer = $ButtonsControl/VBoxLevels
@onready var version_label: Label = $VersionLabel
@onready var back_settings: Button = $ButtonsControl/VBoxSettings/BackSettings
@onready var settings_menu: VBoxContainer = $ButtonsControl/VBoxSettings
@onready var fullscreen_checkbox: CheckBox = $ButtonsControl/VBoxSettings/FullscreenCheckBox
@onready var language_option_button: OptionButton = $ButtonsControl/VBoxSettings/HBoxLanguages/LanguageOptionButton
@onready var language_label: Label = $ButtonsControl/VBoxSettings/HBoxLanguages/LanguageLabel
@onready var reset_progress: Button = $ButtonsControl/VBoxSettings/ResetProgress
@onready var music_volume: HSlider = $ButtonsControl/VBoxSettings/HBoxMusic/MusicVolume
@onready var sfx_volume: HSlider = $ButtonsControl/VBoxSettings/HBoxSFX/SFXVolume
@onready var music_label: Label = $ButtonsControl/VBoxSettings/HBoxMusic/MusicLabel
@onready var sfx_label: Label = $ButtonsControl/VBoxSettings/HBoxSFX/SFXLabel
@onready var main_menu_music: AudioStreamPlayer = $MainMenuMusic

var version = ProjectSettings.get("application/config/version")
var confirm_reset = false

func _ready() -> void:
	main_menu_music.play()
	#Settings
	setup_language_options()
	load_saved_language()
	apply_custom_styles()
	fullscreen_checkbox.button_pressed = SettingsManager.fullscreen
	language_option_button.select(0 if SettingsManager.language == "en" else 1)
	
	music_volume.value = SettingsManager.music_volume
	sfx_volume.value = SettingsManager.sfx_volume
	
	fullscreen_checkbox.toggled.connect(_on_fullscreen_check_box_toggled)
	language_option_button.item_selected.connect(_on_language_option_button_item_selected)
	music_volume.value_changed.connect(_on_music_volume_changed)
	sfx_volume.value_changed.connect(_on_sfx_volume_changed)
	
	update_menu_texts()
	
	version_label.text = "Version: " + version
	for i in range(GameManager.levels.size()):
		var button = find_child("Level" + str(i + 1))
		button.disabled = i >= GameManager.unlocked_levels

func _on_play_pressed() -> void:
	main_menu.visible = false
	level_menu.visible = true

func _on_options_pressed() -> void:
	main_menu.visible = false
	settings_menu.visible = true

func _on_back_pressed() -> void:
	level_menu.visible = false
	settings_menu.visible = false
	main_menu.visible = true
	
	if back_settings:
		SettingsManager.save_settings()

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_level_1_pressed() -> void:
	main_menu_music.stop()
	get_tree().change_scene_to_file("res://scenes/level1.tscn")

func _on_level_2_pressed() -> void:
	main_menu_music.stop()
	get_tree().change_scene_to_file("res://scenes/level2.tscn")

func _on_level_3_pressed() -> void:
	main_menu_music.stop()
	get_tree().change_scene_to_file("res://scenes/level3.tscn")

func _on_level_4_pressed() -> void:
	main_menu_music.stop()
	get_tree().change_scene_to_file("res://scenes/level4.tscn")

func _on_fullscreen_check_box_toggled(toggled_on: bool) -> void:
	SettingsManager.set_fullscreen(toggled_on)

func _on_language_option_button_item_selected(index: int) -> void:
	var selected_language = "en" if index == 0 else "pl"
	SettingsManager.set_language(selected_language)
	TranslationServer.set_locale(selected_language)
	update_menu_texts()

func _on_reset_progress_pressed() -> void:
	if confirm_reset:
		GameManager.reset_progress()
		reset_progress.text = tr("reset_progress")
		confirm_reset = false
	else:
		reset_progress.text = tr("reset_confirm")
		confirm_reset = true
		await get_tree().create_timer(3.0).timeout
		if confirm_reset:
			reset_progress.text = tr("reset_progress")
			confirm_reset = false

func _on_music_volume_changed(value: float) -> void:
	SettingsManager.set_music_volume(value)

func _on_sfx_volume_changed(value: float) -> void:
	SettingsManager.set_sfx_volume(value)

func setup_language_options():
	if language_option_button.get_item_count() == 0:
		language_option_button.add_item("ENGLISH", 0)
		language_option_button.add_item("POLSKI", 1)

func load_saved_language():
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		var lang = config.get_value("Settings", "Language", "en")
		TranslationServer.set_locale(lang)
		language_option_button.select(0 if lang == "en" else 1)

func apply_custom_styles():
	var button_style = get_theme_stylebox("normal", "Button")
	fullscreen_checkbox.add_theme_stylebox_override("normal", button_style)
	fullscreen_checkbox.add_theme_stylebox_override("hover", button_style)
	fullscreen_checkbox.add_theme_stylebox_override("hover_pressed", button_style)
	fullscreen_checkbox.add_theme_stylebox_override("pressed", button_style)
	
	language_label.add_theme_stylebox_override("normal", button_style)
	music_label.add_theme_stylebox_override("normal", button_style)
	sfx_label.add_theme_stylebox_override("normal", button_style)

func update_menu_texts():
	fullscreen_checkbox.text = tr("fullscreen")
	language_label.text = tr("language")
	find_child("ResetProgress").text = tr("reset_progress")
	find_child("Play").text = tr("play")
	find_child("Settings").text = tr("settings")
	find_child("Exit").text = tr("exit")
	find_child("Level1").text = tr("level1")
	find_child("Level2").text = tr("level2")
	find_child("Level3").text = tr("level3")
	find_child("Level4").text = tr("level4")
	find_child("Back").text = tr("back")
	find_child("BackSettings").text = tr("back")
	find_child("MusicLabel").text = tr("music")
	find_child("SFXLabel").text = tr("sfx")

func animate_logo():
	tween.tween_property(logo, "rotation_degrees", 5, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(logo, "rotation_degrees", -5, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(logo, "scale", Vector2(1.05, 1.05), 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(logo, "scale", Vector2(1.0, 1.0), 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.set_loops()
