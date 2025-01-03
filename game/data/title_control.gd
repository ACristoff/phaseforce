extends Control

@onready var pathfollow = $Path2D/PathFollow2D
@onready var music = preload("res://assets/music/PF_MAIN_THEME.mp3")

func _ready():
	AudioManager.play_music(music)

func _physics_process(delta):
	pathfollow.progress += .5


func _on_start_pressed():
	character_select.emit()
	pass # Replace with function body.

signal character_select
