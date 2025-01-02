extends Control

@onready var pathfollow = $Path2D/PathFollow2D
@onready var music = preload("res://assets/music/PF_MAIN_THEME.mp3")

func _ready():
	AudioManager.play_music(music)

func _physics_process(delta):
	pathfollow.progress += .5

func _on__x_720_pressed():
	DisplayServer.window_set_size(Vector2i(1280, 720))
	
func _on__x_900_pressed():
	DisplayServer.window_set_size(Vector2i(1440, 900))

func _on__x_768_pressed():
	DisplayServer.window_set_size(Vector2i(1366, 768))

func _on__x_1080_pressed():
	DisplayServer.window_set_size(Vector2i(1920, 1080))

func _on__x_1440_pressed():
	DisplayServer.window_set_size(Vector2i(2560, 1440))


func _on_start_pressed():
	character_select.emit()
	pass # Replace with function body.

signal character_select
