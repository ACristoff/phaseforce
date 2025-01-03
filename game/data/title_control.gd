extends Control

@onready var pathfollow = $Path2D/PathFollow2D
@onready var cutscene_player = $cutscene
@onready var music = preload("res://assets/music/PF_MAIN_THEME.mp3")
@onready var bpsfx = preload("res://assets/sfx/misc/BERET PARADE Cadence rev 2.mp3")
var sway = false

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
	#AudioManager.play_music(music)
func unlock_sway():
	sway = true
func _physics_process(delta):
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
	character_select.emit()
	pass # Replace with function body.

signal character_select


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "splash":
		cutscene_player.play("cutscene")
		AudioManager.play_music(music)
