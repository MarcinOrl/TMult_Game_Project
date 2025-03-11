extends CanvasLayer

@onready var game_menu_panel: Panel = $GameMenuPanel
@onready var summary_panel: Panel = $SummaryPanel
@onready var summary_time_label: Label = $SummaryPanel/SummaryTimeLabel
@onready var summary_coins_label: Label = $SummaryPanel/SummaryCoinsLabel
@onready var coins_label: Label = $CoinsLabel
@onready var time_label: Label = $TimeLabel

func _ready() -> void:
	coins_label.text = "Coins: 0"
	GameManager.reset()
	
func _process(delta: float) -> void:
	coins_label.text = "Coins: " + str(GameManager.score)
	time_label.text = "Time: " + str(int(GameManager.get_elapsed_time())) + "s"

	if Input.is_action_just_pressed("esc") and not game_menu_panel.visible:
		show_pause_panel()
	elif Input.is_action_just_pressed("esc") and game_menu_panel.visible:
		hide_pause_panel()

func show_summary():
	summary_time_label.text = "Time: " + str(GameManager.get_elapsed_time()) + "s"
	summary_coins_label.text = "Coins: " + str(GameManager.score)
	summary_panel.show()
	
func hide_summary():
	summary_panel.hide()
	
func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_next_level_button_pressed() -> void:
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

# Ukrycie panelu pauzy
func hide_pause_panel():
	game_menu_panel.hide()
