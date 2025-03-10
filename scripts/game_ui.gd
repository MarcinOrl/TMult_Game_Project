extends CanvasLayer

func _ready() -> void:
	$CoinsLabel.text = "Coins: 0"
	GameManager.reset()
	
func _process(delta: float) -> void:
	$CoinsLabel.text = "Coins: " + str(GameManager.score)
	$TimeLabel.text = "Time: " + str(int(GameManager.get_elapsed_time())) + "s"

func show_summary():
	$SummaryPanel/SummaryTimeLabel.text = "Time: " + str(GameManager.get_elapsed_time()) + "s"
	$SummaryPanel/SummaryCoinsLabel.text = "Coins: " + str(GameManager.score)
	$SummaryPanel.show()
	
func hide_summary():
	$SummaryPanel.hide()
	
func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_next_level_button_pressed() -> void:
	if GameManager.current_level_index + 1 < GameManager.levels.size():
		GameManager.current_level_index += 1
		get_tree().change_scene_to_file(GameManager.levels[GameManager.current_level_index])
