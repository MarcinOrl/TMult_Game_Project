extends AudioStreamPlayer

@export var level_music: Dictionary = {
	"res://scenes/level1.tscn": preload("res://assets/music/level1.ogg"),
	"res://scenes/level2.tscn": preload("res://assets/music/level2.ogg"),
	"res://scenes/level3.tscn": preload("res://assets/music/level3.ogg")
}

var current_music: String = ""

func play_music(level_path: String) -> void:
	if level_path == current_music:
		return  
	current_music = level_path

	if level_path in level_music:
		self.stream = level_music[level_path]
		self.play()

func stop_music():
	self.stop()
