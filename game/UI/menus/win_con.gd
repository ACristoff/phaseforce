extends Control

@onready var starone = $CanvasLayer/VBoxContainer/HBoxContainer/Star
@onready var startwo = $CanvasLayer/VBoxContainer/HBoxContainer/Star2
@onready var starthree = $CanvasLayer/VBoxContainer/HBoxContainer/Star3
@onready var time = $CanvasLayer/VBoxContainer/Time
@onready var secrets = $CanvasLayer/VBoxContainer/Secrets
@onready var kills = $CanvasLayer/VBoxContainer/SnowmenKilled
@onready var heli = $InsideHeli
@onready var select_anim = $CanvasLayer/SelectedButtonGraphic/AnimationPlayer
@onready var select_graphic = $CanvasLayer/SelectedButtonGraphic
@onready var retry_button = $CanvasLayer/MarginContainer/Control/HBoxContainer/Retry
@onready var level_select_button = $CanvasLayer/MarginContainer/Control/HBoxContainer/NextLevel
@onready var continue_button = $CanvasLayer/MarginContainer/Control/HBoxContainer/Continue
@onready var main_menu_button = $CanvasLayer/MarginContainer/Control/MarginContainer/MainMenu

#Characters
@onready var panko = $PankoSprite
@onready var lumi = $LumiSprite
@onready var pippa = $PippaSprite
@onready var tenma = $TenmaSprite
@onready var lia = $LiaSprite

@onready var purplestar = preload("res://assets/ui/largestar2.png")
@onready var victory_music = preload("res://assets/music/VICTORY_A.mp3")
@onready var victory_music_b = preload("res://assets/music/VICTORY_B.mp3")

var all_levels_completed = false

var game_man: game_manager
var level_man: Level_Manager

func _star_one_achieved():
	starone.texture = purplestar
func _star_two_achieved():
	startwo.texture = purplestar
func _star_three_achieved():
	starthree.texture = purplestar

func _ready():
	if all_levels_completed == false:
		#AudioManager.play_sfx(victory_music)
		var new_song: AudioStreamPlayer = AudioManager.play_music(victory_music, 0, false)
		AudioManager.music_manager.finished.connect(track_b.bind())
		game_man = get_tree().get_first_node_in_group("game")
		level_man = get_tree().get_first_node_in_group("level_manager")
		print(game_man.current_character)
		var character = game_man.current_character
		if character == "panko":
			panko.visible = true
		if character == "lumi":
			lumi.visible = true
		if character == "pippa":
			pippa.visible = true
		if character == "tenma":
			tenma.visible = true
		if character == "lia":
			lia.visible = true
		retry_button.visible = true
		level_select_button.visible = true
		main_menu_button.visible = true
		continue_button.visible = false
		#$Timer.start()
	else:
		#AudioManager.play_sfx(victory_music)
		var new_song: AudioStreamPlayer = AudioManager.play_music(victory_music, 0, false)
		AudioManager.music_manager.finished.connect(track_b.bind())
		game_man = get_tree().get_first_node_in_group("game")
		level_man = get_tree().get_first_node_in_group("level_manager")
		print(game_man.current_character)
		var character = game_man.current_character
		if character == "panko":
			panko.visible = true
		if character == "lumi":
			lumi.visible = true
		if character == "pippa":
			pippa.visible = true
		if character == "tenma":
			tenma.visible = true
		if character == "lia":
			lia.visible = true
		retry_button.visible = false
		level_select_button.visible = false
		main_menu_button.visible = false
		continue_button.visible = true
		#$Timer.start()

func track_b():
	AudioManager.play_music(victory_music_b)
	pass

func show_stats(data, level_id):
	if data["stars"][0]:
		_star_one_achieved()
	if data["stars"][1]:
		_star_two_achieved()
	if data["stars"][2]:
		_star_three_achieved()
	time.text = str(data.time, " SECONDS")
	secrets.text = str(data.secrets)
	kills.text = str(data.kills)
	#TODO data pass
	game_man.levels_data[str(level_id)] = data

func _on_retry_pressed():
	select_anim.play("selected")
	select_graphic.global_position = $CanvasLayer/MarginContainer/Control/HBoxContainer/Retry.global_position
	await get_tree().create_timer(.8).timeout
	level_man.load_level(level_man.current_level)
	AudioManager.stop_looped()
	queue_free()


func _on_main_menu_pressed():
	select_anim.play("selected")
	select_graphic.global_position = $CanvasLayer/MarginContainer/Control/MarginContainer/MainMenu.global_position
	await get_tree().create_timer(.8).timeout
	game_man.main_menu()
	AudioManager.stop_looped()
	queue_free()


#func _on_level_select_pressed():
	#select_anim.play("selected")
	#select_graphic.global_position = $CanvasLayer/MarginContainer/Control/HBoxContainer/Retry.global_position
	#await get_tree().create_timer(.8).timeout
	#game_man._on_level_select()
	#AudioManager.stop_looped()
	#queue_free()

func _on_next_level_pressed():
	select_anim.play("selected")
	select_graphic.global_position = $CanvasLayer/MarginContainer/Control/HBoxContainer/NextLevel.global_position
	await get_tree().create_timer(.8).timeout
	game_man.on_settings_to_level_select()
	AudioManager.stop_looped()
	queue_free()


func _on_continue_pressed() -> void:
	select_anim.play("selected")
	select_graphic.global_position = $CanvasLayer/MarginContainer/Control/HBoxContainer/Retry.global_position
	await get_tree().create_timer(.8).timeout
	# TO WIN CON END HERE
	AudioManager.stop_looped()
	queue_free()
