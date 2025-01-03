extends Area2D


func _on_body_entered(body):
	if body is BasePlayer:
		body.gain_heart()
		queue_free()
