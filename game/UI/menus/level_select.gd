extends Control


var game_man: game_manager
var level_man: Level_Manager

var dummy_data = { 
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
	#AudioManager.play_sfx(victory_music)
	game_man = get_tree().get_first_node_in_group("game")
	level_man = get_tree().get_first_node_in_group("level_man")
	#print(dummy_data)
	var levels = $CanvasLayer/MarginContainer/HBoxContainer.get_children()
	var count = 1
	for level in levels:
		#print(dummy_data[str(count)])
		var level_data = dummy_data[str(count)]
		if level_data:
			level.update_labels(level_data)
		count += 1
		pass
