extends StaticBody2D

@export var music: AudioStreamMP3 = preload("res://assets/music/Pippa the Ripper.mp3")
#@export var kill_quips: Array[AudioStreamMP3] = [preload("res://assets/music/Pippa the Ripper.mp3")]

func _on_area_2d_body_entered(body):
	#print('body entered record player', body)
	if body is BasePlayer:
		#print('play song')
		AudioManager.play_music(music)
