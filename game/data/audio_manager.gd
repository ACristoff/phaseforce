extends AudioStreamPlayer

var current_music: AudioStreamMP3
var new_music: AudioStreamMP3
var new_volume: int

@onready var fade_timer = $FadeTimer

func _process(delta):
	if new_music && !fade_timer.is_stopped():
		volume_db = volume_db - (30 * delta)

func switch_songs():
	fade_timer.start()

func play_music(music: AudioStreamMP3, volume = 0.0):
	if current_music:
		new_music = music
		new_volume = volume
		switch_songs()
		return
	current_music = music
	stream = music
	volume_db = volume
	play()

func play_sfx(new_stream: AudioStreamMP3, volume = 0.0):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = new_stream
	fx_player.name = "FX_Player"
	fx_player.volume_db = volume
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	fx_player.queue_free()


func play_sfx_wav(new_stream: AudioStreamWAV, volume = 0.0):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = new_stream
	fx_player.name = "FX_Player"
	fx_player.volume_db = volume
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	fx_player.queue_free()


func _on_fade_timer_timeout():
	stream = new_music
	volume_db = new_volume
	play()
	current_music = new_music
	fade_timer.stop()
