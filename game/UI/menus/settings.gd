extends Control

signal back_to_main
signal level_select
signal back_to_game

var has_level

# Called when the node enters the scene tree for the first time.
func _ready():
	#DisplayServer.window_set_size(Vector2i(1920, 1080))
	#process_mode = Node.PROCESS_MODE_WHEN_PAUSED
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


func _on_button_pressed():
	Engine.time_scale = 1
	back_to_main.emit()
	back_to_game.emit()
	get_tree().paused = false
	queue_free()

func _on_h_slider_value_changed(value):
	var new_volume = (value - 5) * 2.5
	AudioManager.global_volume = new_volume
	AudioManager.change_volume()
	prints(value, new_volume)
	pass # Replace with function body.

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
