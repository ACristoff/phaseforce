extends Control

@onready var pathfollow = $Path2D/PathFollow2D
@onready var chopper_pfollow = $ParallaxLayers/Front2/Path2D2/PathFollow2D
@onready var cutscene_player = $cutscene
@onready var music = preload("res://assets/music/PF_MAIN_THEME.mp3")
#@onready var SPLASH = preload("res://game/UI/menus/splash_screen.tscn")
@onready var select_anim = $CanvasLayer/SelectedButtonGraphic/AnimationPlayer
@onready var select_graphic = $CanvasLayer/SelectedButtonGraphic
@onready var canvas = $CanvasLayer
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
	#var splash = SPLASH.instantiate()
	#self.add_child(splash)
	pass

func unlock_sway():
	sway = true

func _physics_process(_delta):
	pass
	if sway == true:
		pathfollow.progress += .5
	else:
		pass

func _on_start_pressed():
	#character_select.emit()
	select_anim.play("selected")
	select_graphic.global_position = $CanvasLayer/MarginContainer/Butttons_Container/VBoxContainer/Start2.global_position
	await get_tree().create_timer(.8).timeout
	on_start.emit()

func post_splash_cutscene():
	cutscene_player.play("cutscene")
	AudioManager.play_music(music)
	
func title_without_splash():
	$copter/PathFollow2D/Minicopter.visible = false
	chopper_pfollow.progress_ratio = 1
	sway = true

func _on_credits_pressed():
	select_anim.play("selected")
	select_graphic.global_position = $CanvasLayer/MarginContainer/Butttons_Container/VBoxContainer/Credits.global_position
	await get_tree().create_timer(.8).timeout
	credits.emit()

func _on_quit_pressed():
	select_anim.play("selected")
	select_graphic.global_position = $CanvasLayer/MarginContainer/Butttons_Container/VBoxContainer/Quit.global_position
	await get_tree().create_timer(.8).timeout
	get_tree().quit()

func _on_options_pressed():
	select_anim.play("selected")
	select_graphic.global_position = $CanvasLayer/MarginContainer/Butttons_Container/VBoxContainer/Options.global_position
	await get_tree().create_timer(.8).timeout
	to_settings.emit()
