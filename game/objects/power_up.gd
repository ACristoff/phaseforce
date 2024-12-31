extends Area2D

func _on_body_entered(body):
	print(body)
	if body is BasePlayer:
		var player: BasePlayer = body
		player.power_up()
	
	queue_free()
