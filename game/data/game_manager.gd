extends Node

class_name game_manager

@onready var title = $Title

@onready var level_manager = preload("res://game/data/level_manager.tscn")
@onready var title_inst = preload("res://game/data/title.tscn")
@onready var credits = preload("res://game/UI/menus/credits.tscn")
@onready var level_select = preload("res://game/UI/menus/level_select.tscn")

@export var debug_mode = false
var current_character = "panko"
@onready var level_man: Level_Manager = $LevelManager


var levels_data = {
	"1": null,
	"2": null,
	"3": null,
	"4": null,
	"5": null
}

var is_paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	DisplayServer.window_set_size(Vector2i(1920, 1080))
	if debug_mode:
		title.queue_free()
		var start_level_man = level_manager.instantiate()
		add_child(start_level_man)
		start_level_man.load_level(0)
		get_tree().set_debug_collisions_hint(true)


func _on_title_character_select():
	var char_select = preload("res://game/UI/menus/character_select.tscn").instantiate()
	#title.queue_free()
	add_child(char_select)
	char_select.chosen_character.connect(selected_character.bind(char_select))


func main_menu():
	var new_title = title_inst.instantiate()
	add_child(new_title)
	new_title.character_select.connect(_on_title_character_select.bind())
	new_title.credits.connect(_on_title_on_start.bind())
	new_title.on_start.connect(_on_title_on_start.bind())
	#new_title.credits.connect()
	title = new_title


func selected_character(new_character, char_screen):
	current_character = new_character
	char_screen.queue_free()
	level_man.to_main.connect(main_menu.bind() )
	level_man.load_level(level_man.current_level)


func _on_title_credits():
	var credits_screen = credits.instantiate()
	add_child(credits_screen) 
	pass # Replace with function body.


func _on_title_on_start():
	var select_screen: LevelSelect = level_select.instantiate()
	select_screen.levels_data = levels_data
	add_child(select_screen)
	title.queue_free()
	pass # Replace with function body.
