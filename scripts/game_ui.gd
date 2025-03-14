extends CanvasLayer

@onready var game_menu_panel: Panel = $Control/GameMenuPanel
@onready var summary_panel: Panel = $Control/SummaryPanel
@onready var summary_time_label: Label = $Control/SummaryPanel/SummaryTimeLabel
@onready var summary_coins_label: Label = $Control/SummaryPanel/SummaryCoinsLabel
@onready var coins_label: Label = $Control/CoinsLabel
@onready var time_label: Label = $Control/TimeLabel
@onready var level_name_label: Label = $Control/LevelNameLabel
@onready var timer: Timer = $Timer

var finish_screen = false

func _ready() -> void:
	GameManager.connect("level_finished", Callable(self, "show_summary"))
	GameManager.score_updated.connect(_on_score_updated)
	GameManager.reset()
	
	if GameManager.is_first_time_loading:
		level_name_label.text = GameManager.get_current_level_name()
		level_name_label.show()
		timer.start()
		GameManager.is_first_time_loading = false
	
func _process(delta: float) -> void:
	if !finish_screen:
		time_label.text = "Time: " + str(int(GameManager.get_elapsed_time())) + "s"

	if Input.is_action_just_pressed("esc") and not game_menu_panel.visible:
		show_pause_panel()
	elif Input.is_action_just_pressed("esc") and game_menu_panel.visible:
		hide_pause_panel()

func show_summary():
	finish_screen = true
	summary_time_label.text = "Time: " + str(GameManager.get_elapsed_time()) + "s"
	summary_coins_label.text = "Coins: " + str(GameManager.score)
	summary_panel.show()
	
func hide_summary():
	summary_panel.hide()
	
func _on_menu_button_pressed() -> void:
	GameManager.reset_first_time_loading()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_next_level_button_pressed() -> void:
	GameManager.reset_first_time_loading()
	if GameManager.current_level_index + 1 < GameManager.levels.size():
		GameManager.current_level_index += 1
		get_tree().change_scene_to_file(GameManager.levels[GameManager.current_level_index])

func _on_resume_button_pressed() -> void:
	hide_pause_panel()

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func show_pause_panel():
	game_menu_panel.show()

func hide_pause_panel():
	game_menu_panel.hide()

func _on_score_updated(new_score):
	coins_label.text = "Coins: " + str(new_score)

func _on_timer_timeout() -> void:
	$Control/LevelNameLabel.hide()
