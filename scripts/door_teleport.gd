extends Area2D

@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var player: Node2D

func _on_body_entered(body: Node2D) -> void:
	animation_player.play("teleport")
	player = body
	player.can_move = false
	player.velocity = Vector2.ZERO
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	player.modulate = Color(1, 1, 1, 1)
	camera.position_smoothing_enabled = false
	camera.limit_bottom = -275
	player.position = Vector2(480, -320)
	await get_tree().create_timer(0.1).timeout
	camera.position_smoothing_enabled = true
	player.can_move = true
