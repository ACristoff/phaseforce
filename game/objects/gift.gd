extends Area2D

class_name Gift

signal gift_collected

func _on_body_entered(body):
	if body is BasePlayer:
		##TODO
		#AudioManager.play_sfx()
		collect_gift()

func collect_gift():
	gift_collected.emit()
	queue_free()
	pass
