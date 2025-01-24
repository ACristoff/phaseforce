extends Control

class_name LevelSelect

var game_man: game_manager
var level_man: Level_Manager
@onready var sfx = preload("res://assets/sfx/UI/CRT_LONG.mp3")
@onready var level_select_music = preload("res://assets/music/PF_LEVEL_SELECT.mp3")

var levels_data = { 
	"1": {
		"secrets": "Secrets found: 0 / 1", 
		"optional_completed": true, 
		"objective": "Objective completed: :3", 
		"kills": "Enemies killed: 20", 
		"stars": [true, true, false], 
		"time": 117, 
		"level": 1
	}, 
	"2": null,
	"3": null, 
	"4": null,
	"5": null
}

func _ready():
	AudioManager.play_sfx(sfx, 1)
	AudioManager.play_music(level_select_music)
	#AudioManager.play_sfx(victory_music)
	game_man = get_tree().get_first_node_in_group("game")
	level_man = get_tree().get_first_node_in_group("level_manager")
	#print(dummy_data)
	var levels = $CanvasLayer/MarginContainer/HBoxContainer.get_children()
	var count = 1
	for level in levels:
		#print(dummy_data[str(count)])
		var level_data = levels_data[str(count)]
		if level_data:
			level.update_labels(level_data)
		level.level_selected.connect(on_level_selected.bind())
		count += 1

func on_level_selected(level_id):
	#print(level_id)
	level_man.current_level = level_id
	game_man._on_title_character_select()
	queue_free()
	pass
