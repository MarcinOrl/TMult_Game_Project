extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal coin_pickup

func _on_body_entered(body: Node2D) -> void:
	coin_pickup.emit()
	animation_player.play("pickup")
