extends Area2D



func _on_body_entered(body: Node2D) -> void:
	body.speed *= 1.3
	body.jump_velocity *= 1.2
	$PickupAnimation.play("pickup")
