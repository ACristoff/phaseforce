extends Node2D

@onready var music = preload("res://assets/music/PF_DEFEAT.mp3")
@onready var anim = $AnimationPlayer

signal retry
signal level_select
signal quit_to_main

func _ready():
	anim.play("you_graduated")
	AudioManager.play_music(music)

func _on_button_pressed():
	retry.emit()
	pass # Replace with function body.

func _on_button_2_pressed():
	quit_to_main.emit()
	pass # Replace with function body.
