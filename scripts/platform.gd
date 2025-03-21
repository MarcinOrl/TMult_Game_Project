extends AnimatableBody2D

@export_enum("Green", "Brown", "Yellow", "Blue") var platform_type: String = "Brown"

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	sprite.region_enabled = true
	
	match platform_type:
		"Green":
			sprite.region_rect = Rect2(16, 0, 32, 9)
		"Brown":
			sprite.region_rect = Rect2(16, 16, 32, 9)
		"Yellow":
			sprite.region_rect = Rect2(16, 32, 32, 9)
		"Blue":
			sprite.region_rect = Rect2(16, 48, 32, 9)
