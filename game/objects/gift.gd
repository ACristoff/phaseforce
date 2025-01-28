extends Area2D

class_name Gift

@onready var pickup_sound: AudioStreamWAV = preload("res://assets/sfx/UI/ITEM_PICKUP.wav")

signal gift_collected

func _on_body_entered(body):
	if body is BasePlayer:
		AudioManager.play_sfx_wav(pickup_sound, -10)
		collect_gift()

func collect_gift():
	gift_collected.emit()
	queue_free()
