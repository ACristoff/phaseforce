extends Node2D

@onready var sfx = preload("res://assets/sfx/misc/KABOOM.mp3")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _explosion_sfx():
	AudioManager.play_sfx(sfx)