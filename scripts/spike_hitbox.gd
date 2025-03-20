extends Area2D

func _on_body_entered(body: Node2D) -> void:
	body.take_damage()
	
	var direction = (body.global_position - global_position).normalized()
	body.velocity += direction * 300
