extends Area2D

@onready var game_ui: CanvasLayer = $"../GameUI"
@onready var player: CharacterBody2D = $"../Player"


func _on_body_entered(body: Node2D) -> void:
	player.can_move = false
	player.velocity = Vector2.ZERO
	GameManager.emit_signal("level_finished")
