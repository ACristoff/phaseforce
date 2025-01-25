extends Area2D

class_name Secret_Area

signal secret_found

@onready var secret_sound = preload("res://assets/sfx/UI/SECRET_FOUND.wav")

var found: bool = false

func _on_body_entered(body):
	if body is BasePlayer && !found:
		AudioManager.play_sfx_wav(secret_sound, -10)
		found = true
		secret_found.emit()
