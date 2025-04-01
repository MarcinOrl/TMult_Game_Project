extends Area2D

@onready var fireball_sound: AudioStreamPlayer2D = $FireballSound
@onready var fireball_explosion_sound: AudioStreamPlayer2D = $FireballExplosionSound

var speed = 120
var direction = Vector2.RIGHT
var fireball_owner: String = ""

func _ready() -> void:
	fireball_sound.play()
	if fireball_owner == "Boss":
		set_collision_mask_value(2, true)
	if fireball_owner == "Player":
		set_collision_mask_value(3, true)
	
	$Sprite2D.flip_h = direction.x < 0

func _process(delta: float) -> void:
	direction.y = 0
	position += direction * speed * delta
	
func _on_timer_timeout() -> void:
	queue_free()

func explode():
	fireball_explosion_sound.play()
	$ExplosionEffect.emitting = true
	await get_tree().create_timer($ExplosionEffect.lifetime + .5).timeout
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Boss" or body.name == "Player":
		body.take_damage()
	$Sprite2D.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	direction = Vector2.ZERO
	explode()
