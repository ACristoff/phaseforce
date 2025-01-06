extends Node

class_name game_manager

@onready var title = $Title

@onready var level_manager = preload("res://game/data/level_manager.tscn")
@onready var title_inst = preload("res://game/data/title.tscn")
@onready var credits = preload("res://game/UI/menus/credits.tscn")
@onready var level_select = preload("res://game/UI/menus/level_select.tscn")
@onready var settings = preload("res://game/UI/menus/settings.tscn")

@export var debug_mode = false
var current_character = "panko"
@onready var level_man: Level_Manager = $LevelManager


var levels_data = {
	"1": {
		"secrets": "Secrets found: 0 / 1", 
		"optional_completed": true, 
		"objective": "Objective completed: :3", 
		"kills": "Enemies killed: 20", 
		"stars": [false, false, false], 
		"time": 0,
		"level": 1
	},
	"2": {
		"secrets": "Secrets found: 0 / 2", 
		"optional_completed": true, 
		"objective": "Objective completed: :3", 
		"kills": "Enemies killed: 20", 
		"stars": [false, false, false], 
		"time": 0, 
		"level": 2
	},
	"3": {
		"secrets": "Secrets found: 0 / 1", 
		"optional_completed": true, 
		"objective": "Objective completed: :3", 
		"kills": "Enemies killed: 20", 
		"stars": [false, false, false], 
		"time": 0, 
		"level": 3
	},
	"4": {
		"secrets": "Secrets found: 0 / 1", 
		"optional_completed": true, 
		"objective": "Objective completed: :3", 
		"kills": "Enemies killed: 20", 
		"stars": [false, false, false], 
		"time": 0, 
		"level": 4
	},
	"5": {
		"secrets": "Secrets found: 0 / 1", 
		"optional_completed": true, 
		"objective": "Objective completed: :3", 
		"kills": "Enemies killed: 20", 
		"stars": [false, false, false], 
		"time": 0, 
		"level": 5
	},
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
	new_title.credits.connect(_on_title_credits.bind())
	new_title.on_start.connect(_on_title_on_start.bind())
	new_title.to_settings.connect(_on_title_to_settings.bind())
	title = new_title


func selected_character(new_character, char_screen):
	current_character = new_character
	char_screen.queue_free()
	level_man.to_main.connect(main_menu.bind() )
	level_man.load_level(level_man.current_level)


func _on_title_credits():
	var credits_screen = credits.instantiate()
	add_child(credits_screen)
	credits_screen.back_to_main.connect(main_menu.bind())
	title.queue_free()
	pass # Replace with function body.


func _on_title_on_start():
	var select_screen: LevelSelect = level_select.instantiate()
	select_screen.levels_data = levels_data
	add_child(select_screen)
	title.queue_free()
	pass # Replace with function body.

func on_settings_to_level_select():
	var select_screen: LevelSelect = level_select.instantiate()
	select_screen.levels_data = levels_data
	add_child(select_screen)


func _on_title_to_settings():
	var settings_menu = settings.instantiate()
	settings_menu.back_to_main.connect(main_menu.bind())
	settings_menu.level_select.connect(on_settings_to_level_select.bind())
	add_child(settings_menu)
	title.queue_free()
	pass # Replace with function body.
