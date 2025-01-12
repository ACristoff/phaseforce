extends Control

signal back_to_main
signal level_select
signal back_to_game

var has_level

@export var sample_sfx: AudioStreamMP3
@export var sample_voice: AudioStreamMP3

@onready var master_volume_slider = $CanvasLayer/NinePatchRect3/Settings/SoundSettings/Master/HBoxContainer/MasterSlider
@onready var music_volume_slider  = $CanvasLayer/NinePatchRect3/Settings/SoundSettings/Music/HBoxContainer/MusicSlider
@onready var voice_volume_slider  = $CanvasLayer/NinePatchRect3/Settings/SoundSettings/Voices/HBoxContainer/VoiceSlider
@onready var sfx_volume_slider    = $CanvasLayer/NinePatchRect3/Settings/SoundSettings/SFX2/HBoxContainer/SFXSlider

var music_bus_name: String  = "Music"
var voice_bus_name: String  = "Voice"
var sfx_bus_name: String    = "SFX"
var master_bus_name: String = "Master"
var master_bus: int
var music_bus: int
var voice_bus: int
var sfx_bus: int

# Called when the node enters the scene tree for the first time.
func _ready():
	master_bus = AudioServer.get_bus_index(master_bus_name)
	music_bus  = AudioServer.get_bus_index(music_bus_name)
	voice_bus  = AudioServer.get_bus_index(voice_bus_name)
	sfx_bus    = AudioServer.get_bus_index(sfx_bus_name)
	master_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus))
	music_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus))
	voice_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(voice_bus))
	sfx_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus))
	#DisplayServer.window_set_size(Vector2i(1920, 1080))
	#process_mode = Node.PROCESS_MODE_WHEN_PAUSED\
	pass

func run_on_pause():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _on_resolution_item_selected(index):
	if index == 0:
		DisplayServer.window_set_size(Vector2i(640, 360))
		#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	elif index == 1:
		DisplayServer.window_set_size(Vector2i(1280, 720))
	elif index == 2:
		DisplayServer.window_set_size(Vector2i(1920, 1080))
		#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	elif index == 3:
		DisplayServer.window_set_size(Vector2i(2560, 1360))
	elif index ==4:
		DisplayServer.window_set_size(Vector2i(2944, 1920))


func _process(delta):
	if Input.is_action_just_pressed("menu") && has_level:
		Engine.time_scale = 1
		back_to_game.emit()
		get_tree().paused = false
		queue_free()
		pass
	pass

func _on_button_pressed():
	Engine.time_scale = 1
	back_to_main.emit()
	back_to_game.emit()
	get_tree().paused = false
	queue_free()



func _on_main_menu_pressed():
	if has_level:
		has_level.queue_free()
		var game_man = get_tree().get_first_node_in_group("game")
		Engine.time_scale = 1
		get_tree().paused = false
		game_man.main_menu()
	else:
		print('selected')
		pass
	back_to_main.emit()
	queue_free()

func _on_level_select_pressed():
	if has_level:
		has_level.queue_free()
		var game_man = get_tree().get_first_node_in_group("game")
		Engine.time_scale = 1
		get_tree().paused = false
		game_man.on_settings_to_level_select()
		pass
	else:
		pass
	level_select.emit()
	queue_free()
	pass # Replace with function body.

func _on_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))

func _on_voice_slider_value_changed(value):
	AudioServer.set_bus_volume_db(voice_bus, linear_to_db(value))

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(value))

func _on_master_slider_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))

func _on_voice_slider_drag_ended(value_changed):
	AudioManager.play_quip(sample_voice)

func _on_sfx_slider_drag_ended(value_changed):
	AudioManager.play_sfx(sample_sfx)
