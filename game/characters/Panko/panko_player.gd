extends BasePlayer


var knockback_force = -4.2
@onready var TRANSEFFECT = preload("res://game/effects/transformation_sequence.tscn")
@onready var in_between_timer: Timer = $Timers/InBetweenTimer
@onready var final_timer: Timer = $Timers/FinalTimer
@onready var in_between_shot_sound: AudioStreamMP3 = preload("res://assets/sfx/projectiles/PF_BOLT_CYCLE_FAST.mp3")
@onready var final_shot_sound: AudioStreamMP3 = preload("res://assets/sfx/projectiles/M1_PING.mp3")

func attack():
	super()
	if !powered_up:
		var knockback_vector = (cursor_spout.global_position - global_position) * knockback_force
		if knockback_vector.y < 0:
			velocity.y = knockback_vector.y * 4
		else:
			knockback_vector.y = knockback_vector.y - 40
			if knockback_vector.y < 0:
				velocity.y = knockback_vector.y * 4
			velocity.y = knockback_vector.y - 30
		knockback = knockback_vector * 3
		if gun_magazine == 0:
			final_timer.start()
		else:
			in_between_timer.start()

func power_up():
	super()
	var trans = TRANSEFFECT.instantiate()
	self.add_child(trans)
	trans.type = 1
	trans.begin()
	trans.global_position = self.global_position


func _on_in_between_timer_timeout():
	AudioManager.play_sfx(in_between_shot_sound)
	pass # Replace with function body.


func _on_final_timer_timeout():
	AudioManager.play_sfx(final_shot_sound)
	pass # Replace with function body.
