extends Node2D
@export var music = preload("res://assets/music/PF_MAIN_THEME.mp3")

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.play_music(music, -20)
	pass # Replace with function body.
