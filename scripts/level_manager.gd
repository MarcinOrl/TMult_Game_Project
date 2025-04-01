extends Node

func _ready() -> void:
	var coins_container = get_tree().current_scene.get_node("Coins")
	if coins_container:
		for coin in coins_container.get_children():
			if coin.has_signal("coin_pickup"):
				if not coin.is_connected("coin_pickup", Callable(GameManager, "add_point")):
					coin.connect("coin_pickup", Callable(GameManager, "add_point"))
	
	if GameManager.is_first_time_loading:
		LevelMusic.play_music(get_tree().current_scene.scene_file_path)

func _input(event):
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
		Engine.time_scale = 1
