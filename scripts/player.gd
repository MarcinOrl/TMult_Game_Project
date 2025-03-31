extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var shoot_timer: Timer = $ShootTimer

signal health_changed(new_lives)

var fireball_scene = preload("res://scenes/fireball.tscn")

var speed = 100.0
var jump_velocity = -250.0
var can_move = true
var max_lives = 3
var current_lives = max_lives
var has_sword = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flip the sprite
	if can_move:
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true
		
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	if can_move:
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_velocity
			$JumpSound.play()
		# Apply movement
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	
	if has_sword and Input.is_action_just_pressed("shoot") and shoot_timer.is_stopped():
		shoot_fire()

	move_and_slide()

func play_fade_out():
	$AnimationPlayer.play("fade_out")

func take_damage():
	current_lives -= 1
	emit_signal("health_changed", current_lives)
	
	if current_lives <= 0:
		die()
	else:
		$HurtSound.play()
		$AnimationPlayer.play("hurt")

func add_live():
	current_lives += 1
	emit_signal("health_changed", current_lives)

func die():
	Engine.time_scale = 0.5
	can_move = false
	get_node("CollisionShape2D").queue_free()
	timer.start()
	$HurtSound.play()

func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()

func shoot_fire():
	var fireball = fireball_scene.instantiate()
	fireball.fireball_owner = "Player"

	var direction = Vector2.RIGHT if animated_sprite.flip_h == false else Vector2.LEFT
	fireball.direction = direction
	fireball.position = position + fireball.direction * 10
	
	get_tree().current_scene.add_child(fireball)
	shoot_timer.start()
