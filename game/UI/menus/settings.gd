extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayServer.window_set_size(Vector2i(1920, 1080))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


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
	queue_free()
