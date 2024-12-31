extends Node

class_name game_manager

@onready var title = $Title

@onready var level_manager = preload("res://game/data/level_manager.tscn")

@export var debug_mode = false
var current_character 


# Called when the node enters the scene tree for the first time.
func _ready():
	if debug_mode:
		title.queue_free()
		var start_level_man = level_manager.instantiate()
		add_child(start_level_man)
		start_level_man.load_level(0)
		pass


func _on_title_character_select():
	var char_select = preload("res://game/UI/menus/character_select.tscn").instantiate()
	title.queue_free()
	add_child(char_select)
	char_select.chosen_character.connect(selected_character.bind(char_select))

func selected_character(new_character, char_screen):
	current_character = new_character
	char_screen.queue_free()
	var start_level_man = level_manager.instantiate()
	add_child(start_level_man)
	start_level_man.load_level(0)
