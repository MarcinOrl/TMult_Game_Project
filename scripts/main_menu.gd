extends Control

@onready var main_menu: VBoxContainer = $VBoxButtons
@onready var level_menu: VBoxContainer = $VBoxLevels

func _ready() -> void:
	level_menu.visible = false

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
