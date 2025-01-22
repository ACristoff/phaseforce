extends Area2D

@export var teleport_position: Marker2D
@onready var teleport_timer: Timer = $Timer
@onready var teleport_sound: AudioStreamMP3 = preload("res://assets/sfx/misc/TELEPORT.mp3")
var player_ref: BasePlayer

func _on_body_entered(body):
	if body is BasePlayer && teleport_timer.is_stopped():
		#teleport_player(body)
		player_ref = body 
		start_teleport(body)

func start_teleport(player: BasePlayer):
	AudioManager.play_sfx(teleport_sound)
	teleport_timer.start()
	player.is_teleporting = true
	player.anim_player.play('teleport')

func teleport_player(player: BasePlayer):
	player.global_position = teleport_position.global_position


func _on_timer_timeout():
	teleport_player(player_ref)
