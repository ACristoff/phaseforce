extends Node

var current_music: AudioStreamMP3
var new_music: AudioStreamMP3
var new_volume: int

@onready var fade_timer: Timer = $MusicManager/FadeTimer
@onready var music_manager: AudioStreamPlayer = $MusicManager

var has_looped_sfx
var loop_music = true

func _process(delta):
	if new_music && !fade_timer.is_stopped():
		music_manager.volume_db = music_manager.volume_db - (30 * delta)

func switch_songs():
	fade_timer.start()

func play_music(music: AudioStreamMP3, volume = 0.0, looped = true):
	#music_manager.playing = true
	if current_music:
		new_music = music
		new_volume = volume
		switch_songs()
		return
	loop_music = looped
	current_music = music
	current_music.set_loop(looped)
	music_manager.stream = music
	music_manager.volume_db = volume
	music_manager.play()
	#return music_manager

func play_sfx(new_stream: AudioStreamMP3, volume = 0.0, looped = false):
	var fx_player: AudioStreamPlayer = AudioStreamPlayer.new()
	new_stream.set_loop(looped)
	fx_player.stream = new_stream
	fx_player.name = "FX_Player"
	fx_player.bus = "SFX"
	fx_player.volume_db = volume
	add_child(fx_player)
	fx_player.play()
	if looped == false:
		fx_player.finished.connect(on_sound_finished.bind(fx_player))
	else:
		has_looped_sfx = fx_player
	return fx_player

func create_2d_sfx(new_stream: AudioStreamWAV, volume = 0.0, looped = false):
	var fx_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	new_stream.set_loop(looped)
	fx_player.stream = new_stream
	fx_player.name = "FX_Player_2D"
	fx_player.bus = "SFX"
	fx_player.volume_db = volume
	#add_child(fx_player)
	fx_player.play()
	if looped == false:
		fx_player.finished.connect(on_sound_finished.bind(fx_player))
	else:
		has_looped_sfx = fx_player
	return fx_player

func play_sfx_wav(new_stream: AudioStreamWAV, volume = 0.0, looped = false):
	var fx_player: AudioStreamPlayer = AudioStreamPlayer.new()
	#new_stream.set_loop(looped)
	fx_player.stream = new_stream
	fx_player.name = "FX_Player"
	fx_player.bus = "SFX"
	fx_player.volume_db = volume
	add_child(fx_player)
	fx_player.play()
	if looped == false:
		fx_player.finished.connect(on_sound_finished.bind(fx_player))
	else:
		has_looped_sfx = fx_player
	return fx_player

func play_quip(new_stream: AudioStreamMP3, volume = 0.0):
	var fx_player: AudioStreamPlayer = AudioStreamPlayer.new()
	fx_player.stream = new_stream
	fx_player.name = "FX_Player"
	fx_player.volume_db = volume
	fx_player.bus = "Voice"
	add_child(fx_player)
	fx_player.play()
	fx_player.finished.connect(on_sound_finished.bind(fx_player ))
	
	return fx_player

func _on_fade_timer_timeout():
	music_manager.stream = new_music
	music_manager.volume_db = new_volume
	music_manager.play()
	current_music = new_music

func on_sound_finished(sound_player):
	sound_player.queue_free()

func stop_looped():
	if has_looped_sfx:
		has_looped_sfx.queue_free()


func _on_music_manager_finished():
	if loop_music == false:
		current_music = null
		music_manager.stop()
	pass # Replace with function body.
