extends Area2D

@export var teleport_position: Marker2D

func _on_body_entered(body):
	if body is BasePlayer:
		teleport_player(body)

func teleport_player(player: BasePlayer):
	player.global_position = teleport_position.global_position