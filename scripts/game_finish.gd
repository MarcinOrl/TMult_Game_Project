extends Area2D

func _on_body_entered(body: Node2D) -> void:
	body.can_move = false
	body.velocity = Vector2.ZERO
	body.play_fade_out()
	GameManager.emit_signal("game_finished")
