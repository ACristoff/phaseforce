extends Node2D

@onready var starone = $HBoxContainer/Star
@onready var startwo = $HBoxContainer/Star2
@onready var starthree = $HBoxContainer/Star3
@onready var purplestar = preload("res://assets/ui/largestar2.png")
@onready var victory_music = preload("res://assets/music/VICTORY_A.mp3")
@onready var victory_music_b = preload("res://assets/music/VICTORY_B.mp3")

func _star_one_achieved():
	starone.texture = purplestar
func _star_two_achieved():
	startwo.texture = purplestar
func _star_three_achieved():
	starthree.texture = purplestar

func _ready():
	AudioManager.play_sfx(victory_music)


func show_stats(data):
	print(data)
	
	pass
