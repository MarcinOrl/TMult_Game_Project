extends Node

var unlocked_levels = 1
var levels = ["res://scenes/level1.tscn", "res://scenes/level2.tscn", "res://scenes/level3.tscn", "res://scenes/level4.tscn"]
var current_level_index = 0

var score = 0
var start_time = 0

var is_first_time_loading = true

signal level_finished
signal score_updated

func _ready() -> void:
	load_progress()
	self.connect("level_finished", Callable(self, "unlock_next_level"))

func get_current_level_name() -> String:
	var scene_path = get_tree().current_scene.scene_file_path
	match scene_path:
		"res://scenes/level1.tscn": return tr("level1")
		"res://scenes/level2.tscn": return tr("level2")
		"res://scenes/level3.tscn": return tr("level3")
		"res://scenes/level4.tscn": return tr("level4")
	return "UNKNOWN LEVEL"

func add_point():
	score += 1
	score_updated.emit(score)
	
func start_timer():
	start_time = Time.get_ticks_msec()
	
func get_elapsed_time():
	return (Time.get_ticks_msec() - start_time) / 1000.0

func reset():
	score = 0
	start_timer()

func get_score():
	return score

func set_current_level(path: String) -> void:
	if path in levels:
		current_level_index = levels.find(path)

func unlock_next_level():
	set_current_level(get_tree().current_scene.scene_file_path)
	if unlocked_levels < levels.size() and current_level_index == unlocked_levels - 1:
		unlocked_levels += 1
		save_progress()
		
func save_progress():
	var save_data = {"unlocked_levels": unlocked_levels}
	var file = FileAccess.open("user://progress.save", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	
func load_progress():
	if FileAccess.file_exists("user://progress.save"):
		var file = FileAccess.open("user://progress.save", FileAccess.READ)
		var save_data = JSON.parse_string(file.get_as_text())
		if save_data and "unlocked_levels" in save_data:
			unlocked_levels = save_data["unlocked_levels"]

func reset_first_time_loading():
	is_first_time_loading = true

func reset_progress():
	unlocked_levels = 1
	save_progress()
	get_tree().reload_current_scene()
