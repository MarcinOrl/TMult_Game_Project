extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body.current_lives < body.max_lives:
		body.add_live()
		$PickupAnimation.play("pickup")
