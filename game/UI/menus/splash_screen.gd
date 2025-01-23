extends Control

@onready var bpsfx = preload("res://assets/sfx/misc/BERET PARADE Cadence rev 2.mp3")
@onready var bereparedosfx = [
	preload("res://assets/sfx/b00/b01.wav"),
	preload("res://assets/sfx/b00/b02.wav"),
	preload("res://assets/sfx/b00/b03.wav"),
	preload("res://assets/sfx/b00/b04.wav"),
	preload("res://assets/sfx/b00/b05.wav"),
	preload("res://assets/sfx/b00/b06.wav"),
	preload("res://assets/sfx/b00/b07.wav"),
	preload("res://assets/sfx/b00/b08.wav"),
	preload("res://assets/sfx/b00/b09.wav"),
]

func _play_splash_sfx():
	AudioManager.play_sfx(bpsfx)
func _play_beretchan_sfx():
	var random = randi_range(0,8)
	AudioManager.play_sfx_wav(bereparedosfx[random], 1)
	var game_man: game_manager = get_tree().get_first_node_in_group('game')
	game_man.main_menu(true)

func _on_splash_anim_animation_finished(anim_name):
	if anim_name == 'splash':
		var game_man: game_manager = get_tree().get_first_node_in_group('game')
		game_man.main_cutscene()
		game_man.title.canvas.visible = true
		queue_free()
	pass # Replace with function body.
