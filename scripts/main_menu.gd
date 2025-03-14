extends Control

@onready var main_menu: VBoxContainer = $VBoxButtons
@onready var level_menu: VBoxContainer = $VBoxLevels
@onready var version_label: Label = $VersionLabel

var version = ProjectSettings.get("application/config/version")

func _ready() -> void:
	version_label.text = "Version: " + version
	level_menu.visible = false
	for i in range(GameManager.levels.size()):
		var button = find_child("Level" + str(i + 1))
		button.disabled = i >= GameManager.unlocked_levels

func _on_play_pressed() -> void:
	main_menu.visible = false
	level_menu.visible = true
	
func _on_back_pressed() -> void:
	level_menu.visible = false
	main_menu.visible = true

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level1.tscn")

func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level2.tscn")

func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level3.tscn")
