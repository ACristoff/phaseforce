extends Control

@onready var pathfollow = $Path2D/PathFollow2D
@onready var cutscene_player = $cutscene
@onready var music = preload("res://assets/music/PF_MAIN_THEME.mp3")
@onready var bpsfx = preload("res://assets/sfx/misc/BERET PARADE Cadence rev 2.mp3")
var sway = false

signal character_select
signal credits
signal on_start
signal to_settings

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


func _ready():
	pass

func unlock_sway():
	sway = true

func _physics_process(_delta):
	pass
	if sway == true:
		pathfollow.progress += .5
	else:
		pass

func _play_splash_sfx():
	AudioManager.play_sfx(bpsfx)
func _play_beretchan_sfx():
	var random = randi_range(0,8)
	AudioManager.play_sfx_wav(bereparedosfx[random], 1)

func _on_start_pressed():
	#character_select.emit()
	on_start.emit()
	pass # Replace with function body.

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "splash":
		cutscene_player.play("cutscene")
		AudioManager.play_music(music)

func _on_credits_pressed():
	credits.emit()
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_options_pressed():
	to_settings.emit()
	pass # Replace with function body.
