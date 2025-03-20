extends Area2D

var speed = 200
var direction = Vector2.RIGHT

func _process(delta: float) -> void:
	position += direction * speed * delta
	
func _on_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	#Implementacja obrazen przeciwnikowi lub zniszczenia o element gry
	queue_free()
