extends Area2D

var speed = 200
var direction = Vector2.RIGHT
var fireball_owner: String = ""

func _ready() -> void:
	if fireball_owner == "Boss":
		set_collision_mask_value(2, true)
	if fireball_owner == "Player":
		set_collision_mask_value(3, true)

func _process(delta: float) -> void:
	position += direction * speed * delta
	
func _on_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Boss" or body.name == "Player":
		body.take_damage()
	queue_free()
