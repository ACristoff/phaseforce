extends StaticBody2D

@export var music = preload("res://assets/music/Pippa the Ripper.mp3")


func _on_area_2d_body_entered(body):
	print('body entered record player', body)
	if body is BasePlayer:
		AudioManager.play_music(music)
