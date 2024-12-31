extends Node

class_name game_manager

@onready var title = $Title2

@onready var level_manager = preload("res://game/data/level_manager.tscn")

@export var debug_mode = false
var current_character = "panko"


# Called when the node enters the scene tree for the first time.
func _ready():
	if debug_mode:
		title.queue_free()
		var start_level_man = level_manager.instantiate()
		add_child(start_level_man)
		start_level_man.load_level(0)

func _on_title_character_select():
	var char_select = preload("res://game/UI/menus/character_select.tscn").instantiate()
	title.queue_free()
	add_child(char_select)
	char_select.chosen_character.connect(selected_character.bind(char_select))

func selected_character(new_character, char_screen):
	current_character = new_character
	char_screen.queue_free()
	var level_man = level_manager.instantiate()
	add_child(level_man)
	level_man.load_level(0)
	#level_man.use_character(current_character)

#For the second title UI
func _on_title_2_character_select() -> void:
	var char_select = preload("res://game/UI/menus/character_select.tscn").instantiate()
	title.queue_free()
	add_child(char_select)
	char_select.chosen_character.connect(selected_character.bind(char_select))
