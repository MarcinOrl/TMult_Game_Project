extends Node

var levels = ["res://scenes/level1.tscn", "res://scenes/level2.tscn", "res://scenes/level3.tscn"]
var current_level_index = 0

var score = 0
var start_time = 0

signal level_finished
signal score_updated

func _ready() -> void:
	set_current_level(get_tree().current_scene.scene_file_path)

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
