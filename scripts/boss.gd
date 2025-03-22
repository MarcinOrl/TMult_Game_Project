extends CharacterBody2D

@onready var player: CharacterBody2D = %Player
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_bar: ProgressBar = %GameUI.get_node("Control/BossHealthBar")
@onready var shoot_timer: Timer = $ShootTimer
@onready var boss_spawner: Area2D = $"../BossSpawner"

var health = 100
var is_dead = false
var speed = 30
var shoot_cooldown = 2.0
var fireball_scene = preload("res://scenes/fireball.tscn")

func _ready() -> void:
	self.hide()
	health_bar.visible = false

	shoot_timer.start(shoot_cooldown)
	shoot_timer.connect("timeout", Callable(self, "_on_shoot_timer_timeout"))

	boss_spawner.connect("body_entered", Callable(self, "_on_boss_spawner_body_entered"))

func _process(delta: float) -> void:
	if player and !is_dead and is_visible():
		move_towards_player(delta)

func move_towards_player(delta: float):
	var direction = (player.global_position - global_position).normalized()
	direction.y = 0
	velocity = direction * speed
	move_and_slide()
	
	animated_sprite.flip_h = player.global_position.x < global_position.x

func take_damage():
	if is_dead:
		return
		
	health -= 10
	update_health_bar()	
	if health <= 0:
		die()
	else:
		animated_sprite.modulate = Color(1, 0, 0, 1)
		await get_tree().create_timer(0.3).timeout
		animated_sprite.modulate = Color(1, 1, 3, 1)

func die():
	is_dead = true
	animated_sprite.play("death")
	get_node("CollisionShape2D").queue_free()
	get_node("EnemyHitbox").queue_free()
	velocity = Vector2.ZERO
	animated_sprite.modulate = Color(1, 0, 0, 1)
	await get_tree().create_timer(0.3).timeout
	animated_sprite.modulate = Color(1, 1, 3, 1)

func update_health_bar():
	health_bar.value = health

func _on_shoot_timer_timeout() -> void:
	if !is_dead:
		shoot_fireball()

func shoot_fireball():
	var fireball = fireball_scene.instantiate()
	fireball.fireball_owner = "Boss"
	get_parent().add_child(fireball)
	fireball.position = global_position
	var direction = (player.global_position - global_position).normalized()
	direction.y = 0
	fireball.direction = direction

func _on_boss_spawner_body_entered(body: Node2D) -> void:
	show_boss()

# Funkcja do pokazania bossa
func show_boss():
	self.show()
	health_bar.visible = true 
