extends AudioStreamPlayer

var current_music: AudioStreamMP3
var new_music: AudioStreamMP3
var new_volume: int

@onready var fade_timer = $FadeTimer

var global_volume = 0 
var dampener = -25
var has_looped

func _process(delta):
	if new_music && !fade_timer.is_stopped():
		volume_db = volume_db - (30 * delta)

func switch_songs():
	fade_timer.start()

func change_volume():
	volume_db = global_volume + dampener

func play_looped(new_stream: AudioStreamMP3, volume = 0.0):
	var fx_player = AudioStreamPlayer.new()
	var looped_stream = new_stream
	looped_stream.set_loop(true)
	fx_player.stream = new_stream
	#fx_player.stream
	fx_player.name = "FX_Player"
	fx_player.volume_db = volume + global_volume + dampener
	add_child(fx_player)
	fx_player.play()
	has_looped = fx_player

func stop_looped():
	if has_looped:
		has_looped.queue_free()

func play_music(music: AudioStreamMP3, volume = 0.0):
	prints(music, global_volume, volume_db)
	#change_volume()
	playing = true
	if current_music:
		new_music = music
		new_volume = volume + dampener
		switch_songs()
		return
	current_music = music
	current_music.set_loop(true)
	stream = music
	#stream
	volume_db = volume + dampener
	play()

#func stop_music(_do_fade):
	#if _do_fade:
		#fade_timer.start()
	#playing = false
	#pass

func play_sfx(new_stream: AudioStreamMP3, volume = 0.0):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = new_stream
	fx_player.name = "FX_Player"
	fx_player.volume_db = volume + global_volume + dampener
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	fx_player.queue_free()

func play_quip(new_stream: AudioStreamMP3, volume = 0.0):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = new_stream
	fx_player.name = "FX_Player"
	fx_player.volume_db = volume + global_volume + dampener
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	fx_player.queue_free()

func play_sfx_wav(new_stream: AudioStreamWAV, volume = 0.0):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = new_stream
	fx_player.name = "FX_Player"
	fx_player.volume_db = volume + global_volume + dampener
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	fx_player.queue_free()


func _on_fade_timer_timeout():
	#print('play the new song')
	stream = new_music
	volume_db = new_volume
	play()
	current_music = new_music
	fade_timer.stop()
