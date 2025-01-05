extends Node2D

@onready var starone = $CanvasLayer/VBoxContainer/HBoxContainer/Star
@onready var startwo = $CanvasLayer/VBoxContainer/HBoxContainer/Star2
@onready var starthree = $CanvasLayer/VBoxContainer/HBoxContainer/Star3
@onready var time = $CanvasLayer/VBoxContainer/Time
@onready var secrets = $CanvasLayer/VBoxContainer/Secrets
@onready var kills = $CanvasLayer/VBoxContainer/SnowmenKilled
@onready var purplestar = preload("res://assets/ui/largestar2.png")
@onready var victory_music = preload("res://assets/music/VICTORY_A.mp3")
@onready var victory_music_b = preload("res://assets/music/VICTORY_B.mp3")

#var level_

func _star_one_achieved():
	starone.texture = purplestar
func _star_two_achieved():
	startwo.texture = purplestar
func _star_three_achieved():
	starthree.texture = purplestar

func _ready():
	AudioManager.play_sfx(victory_music)
	#_star_one_achieved()
	#_star_two_achieved()
	#_star_three_achieved()


func show_stats(data, level_id):
	#print(data)
	if data["stars"][0]:
		_star_one_achieved()
	if data["stars"][1]:
		_star_two_achieved()
	if data["stars"][2]:
		_star_three_achieved()
	time.text = str(data.time)
	secrets.text = str(data.secrets)
	kills.text = str(data.kills)
	var manager: game_manager = get_tree().get_first_node_in_group("game")
	#TODO data pass
	manager.levels_data[str(level_id)] = data
	#print(manager.levels_data)
	pass

	#var all = {
		#"secrets": secrets_data,
		#"optional_completed": optional_completed,
		#"objective": objective,
		#"secrets_data": secrets_data,
		#"enemies": enemies,
		#"stars": stars
	#}
