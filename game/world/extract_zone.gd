extends Node2D

signal player_extracted

func _on_area_2d_body_entered(body):
	if body is BasePlayer:
		print('extracted!')
		pass
	pass # Replace with function body.