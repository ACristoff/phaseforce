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


func _on_main_menu_pressed():
	var game_man: game_manager = get_tree().get_first_node_in_group('game')
	game_man.
	pass # Replace with function body.
