extends Control

@onready var main_menu: VBoxContainer = $VBoxButtons
@onready var level_menu: VBoxContainer = $VBoxLevels
@onready var version_label: Label = $VersionLabel
@onready var settings_menu: VBoxContainer = $VBoxSettings
@onready var fullscreen_checkbox: CheckBox = $VBoxSettings/FullscreenCheckBox
@onready var language_option_button: OptionButton = $VBoxSettings/HBoxLanguages/LanguageOptionButton
@onready var language_label: Label = $VBoxSettings/HBoxLanguages/LanguageLabel

var version = ProjectSettings.get("application/config/version")

func _ready() -> void:
	#Settings
	apply_custom_styles()
	fullscreen_checkbox.button_pressed = SettingsManager.fullscreen
	language_option_button.select(SettingsManager.language_index)
	fullscreen_checkbox.toggled.connect(_on_fullscreen_check_box_toggled)
	language_option_button.item_selected.connect(_on_language_option_button_item_selected)
	
	version_label.text = "Version: " + version
	level_menu.visible = false
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
	SettingsManager.set_language(index)

func apply_custom_styles():
	var button_style = get_theme_stylebox("normal", "Button")
	fullscreen_checkbox.add_theme_stylebox_override("normal", button_style)
	fullscreen_checkbox.add_theme_stylebox_override("hover", button_style)
	fullscreen_checkbox.add_theme_stylebox_override("hover_pressed", button_style)
	fullscreen_checkbox.add_theme_stylebox_override("pressed", button_style)
	
	language_label.add_theme_stylebox_override("normal", button_style)
