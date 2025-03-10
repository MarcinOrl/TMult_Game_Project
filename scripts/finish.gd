extends Area2D

@onready var game_ui: CanvasLayer = $"../GameUI"
@onready var player: CharacterBody2D = $"../Player"

func _on_body_entered(body: Node2D) -> void:
	game_ui.show_summary()
	player.can_move = false
	player.velocity = Vector2.ZERO
