extends Node

class_name Level_Manager

@export var levels: Array[PackedScene] = []

#var panko = load("res://game/characters/base_player.tscn")
var characters = {
	"panko": load("res://game/characters/Panko/panko_player.tscn"),
	"lia": load("res://game/characters/base_player.tscn"),
	"tenma": load("res://game/characters/base_player.tscn"),
	"pippa": load("res://game/characters/base_player.tscn")
}

func load_level(id):
	var new_level = levels[id].instantiate()
	var game_man: game_manager = get_node("/root/GameManager")
	new_level.character = characters[game_man.current_character]
	add_child(new_level)
