extends Node2D

@onready var music = preload("res://assets/music/PF_DEFEAT.mp3")
@onready var anim = $AnimationPlayer
@onready var select_anim = $CanvasLayer/SelectedButtonGraphic/AnimationPlayer
@onready var select_graphic = $CanvasLayer/SelectedButtonGraphic
var level

signal retry
signal level_select
signal quit_to_main

func _ready():
	anim.play("you_graduated")
	AudioManager.play_music(music)
	level = get_tree().get_first_node_in_group("level")

func _on_button_pressed():
	select_anim.play("selected")
	select_graphic.global_position = $CanvasLayer/Control/MarginContainer/VBoxContainer3/VBoxContainer2/Button.global_position
	await get_tree().create_timer(.8).timeout
	level.queue_free()
	retry.emit()
	pass # Replace with function body.

func _on_button_2_pressed():
	select_anim.play("selected")
	select_graphic.global_position = $CanvasLayer/Control/MarginContainer/VBoxContainer3/VBoxContainer2/Button2.global_position
	await get_tree().create_timer(.8).timeout
	queue_free()
	quit_to_main.emit()
