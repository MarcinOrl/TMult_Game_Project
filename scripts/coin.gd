extends Area2D

signal coin_pickup

func _on_body_entered(body: Node2D) -> void:
	coin_pickup.emit()
	queue_free()
