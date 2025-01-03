extends Node

class_name Level_Manager

@export var levels: Array[PackedScene] = []

@onready var fail_screen = preload("res://game/UI/menus/game_over.tscn")
@onready var level_transition_screen = preload("res://game/UI/menus/win_con.tscn")

var level_ref: Level
var current_level = 0

var characters = {
	"panko": load("res://game/characters/Panko/panko_player.tscn"),
	"lia": load("res://game/characters/lia/lia_player.tscn"),
	"tenma": load("res://game/characters/tenma/tenma_player.tscn"),
	"pippa": load("res://game/characters/Panko/panko_player.tscn")
}


func load_level(id):
	current_level = id
	var new_level: Level = levels[id].instantiate()
	var game_man: game_manager = get_node("/root/GameManager")
	new_level.character = characters[game_man.current_character]
	new_level.level_completed.connect(_on_level_complete.bind())
	add_child(new_level)
	level_ref = new_level
	
	print(level_ref, level_ref.level_completed.is_connected(_on_level_complete))


##TODO
func _on_death():
	level_ref.queue_free()
	load_level(current_level)


func _on_level_complete(data):
	print('do complete level', data)
	var transition = level_transition_screen.instantiate()
	level_ref.queue_free()
	add_child(transition)


##TODO
func next_level():
	load_level(current_level + 1)
	pass
