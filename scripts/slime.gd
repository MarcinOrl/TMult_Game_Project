extends Node2D

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 40

var direction = 1
var is_dead = false

func _process(delta: float) -> void:
	if is_dead:
		return
		
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
		
	position.x += direction * SPEED * delta

func _on_slime_killzone_body_entered(body: Node2D) -> void:
	animation_player.play("smash")
	is_dead = true
