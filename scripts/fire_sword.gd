extends Area2D

func _on_body_entered(body: Node2D) -> void:
	$PickupAnimation.play("pickup")
	body.has_sword = true
