extends Node

class_name Level_Manager

@export var levels: Array[PackedScene] = []

@onready var fail_screen = preload("res://game/UI/menus/game_over.tscn")
@onready var level_transition_screen = preload("res://game/UI/menus/win_con.tscn")
#@onready var 

var level_ref: Level
var fail_ref
var current_level = 1
var time
signal to_main

var characters = {
	"panko": load("res://game/characters/Panko/panko_player.tscn"),
	"lia": load("res://game/characters/lia/lia_player.tscn"),
	"tenma": load("res://game/characters/tenma/tenma_player.tscn"),
	"pippa": load("res://game/characters/pippa/pippa_player.tscn"),
	"lumi": load("res://game/characters/lumi/lumi_player.tscn")
}

func load_level(id):
	current_level = id
	#print(levels)
	var new_level: Level = levels[id].instantiate()
	var game_man: game_manager = get_node("/root/GameManager")
	new_level.character = characters[game_man.current_character]
	new_level.level_completed.connect(_on_level_complete.bind())
	new_level.game_over.connect(_on_death.bind())
	level_ref = new_level
	add_child(new_level)
	new_level.level_id = current_level

func _on_death():
	var fail = fail_screen.instantiate()
	#level_ref.queue_free()
	#player.is
	var player: BasePlayer = get_tree().get_first_node_in_group("player")
	player.is_active = false
	#player.queue_free()
	fail.retry.connect(_on_restart.bind())
	#fail.quit_to_main.connect(_to_main.bind())
	fail.quit_to_main.connect(_on_clicked_to_main.bind())
	add_child(fail)
	fail_ref = fail

##TODO
func _on_clicked_to_main():
	to_main.emit()
	var fail = get_child(0)
	fail.queue_free()

func _on_restart():
	#level_ref.queue_free()
	fail_ref.queue_free()
	#print(get_children())
	#level_ref.reload_current_scene()
	load_level(current_level)

func _on_level_complete(data):
	#print('do complete level', data)
	var transition = level_transition_screen.instantiate()
	level_ref.queue_free()
	
	add_child(transition)
	##TODO ADD SIGNAL CONNECTIONS
	transition.show_stats(data, current_level)

##TODO
func next_level():
	print('test')
	load_level(current_level + 1)
	pass
