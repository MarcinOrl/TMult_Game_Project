extends Control

@onready var logo: TextureRect = $Logo
@onready var tween = get_tree().create_tween()
@onready var main_menu: VBoxContainer = $VBoxButtons
@onready var level_menu: VBoxContainer = $VBoxLevels
@onready var version_label: Label = $VersionLabel
@onready var settings_menu: VBoxContainer = $VBoxSettings
@onready var fullscreen_checkbox: CheckBox = $VBoxSettings/FullscreenCheckBox
@onready var language_option_button: OptionButton = $VBoxSettings/HBoxLanguages/LanguageOptionButton
@onready var language_label: Label = $VBoxSettings/HBoxLanguages/LanguageLabel

var version = ProjectSettings.get("application/config/version")

func _ready() -> void:
	#animate_logo()
	#Settings
	setup_language_options()
	load_saved_language()
	apply_custom_styles()
	fullscreen_checkbox.button_pressed = SettingsManager.fullscreen
	language_option_button.select(0 if SettingsManager.language == "en" else 1)
	
	fullscreen_checkbox.toggled.connect(_on_fullscreen_check_box_toggled)
	language_option_button.item_selected.connect(_on_language_option_button_item_selected)
	
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

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level1.tscn")

func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level2.tscn")

func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level3.tscn")

func _on_fullscreen_check_box_toggled(toggled_on: bool) -> void:
	SettingsManager.set_fullscreen(toggled_on)

func _on_language_option_button_item_selected(index: int) -> void:
	var selected_language = "en" if index == 0 else "pl"
	SettingsManager.set_language(selected_language)
	TranslationServer.set_locale(selected_language)
	update_menu_texts()

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

func update_menu_texts():
	fullscreen_checkbox.text = tr("fullscreen")
	language_label.text = tr("language")
	find_child("Play").text = tr("play")
	find_child("Settings").text = tr("settings")
	find_child("Exit").text = tr("exit")
	find_child("Level1").text = tr("level1")
	find_child("Level2").text = tr("level2")
	find_child("Level3").text = tr("level3")
	find_child("Back").text = tr("back")

func animate_logo():
	tween.tween_property(logo, "rotation_degrees", 5, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(logo, "rotation_degrees", -5, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(logo, "scale", Vector2(1.05, 1.05), 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(logo, "scale", Vector2(1.0, 1.0), 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.set_loops()
