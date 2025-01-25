extends BasePlayer


var knockback_force = -4.2
@onready var TRANSEFFECT = preload("res://game/effects/transformation_sequence.tscn")
@onready var in_between_timer: Timer = $Timers/InBetweenTimer
@onready var final_timer: Timer = $Timers/FinalTimer
@onready var in_between_shot_sound: AudioStreamMP3 = preload("res://assets/sfx/projectiles/PF_BOLT_CYCLE_FAST.mp3")
@onready var final_shot_sound: AudioStreamMP3 = preload("res://assets/sfx/projectiles/M1_PING.mp3")

func attack():
	muzzle_flash.play("muzzlef")
	
	muzzle_flash.play("muzzlef")
	gun_anim.stop()
	gun_anim.play("kickback")
	var new_bullet = bullet.instantiate()
	var new_shell = shell.instantiate()
	new_bullet.damage = bullet_damage
	new_bullet.speed = bullet_speed
	new_bullet.global_position = cursor_spout.global_position
	new_shell.global_position = shell_spout.global_position
	var adjusted_angle = cursor.rotation_degrees + randi_range(gun_spread[0],gun_spread[1])
	new_bullet.rotation_degrees = adjusted_angle
	get_parent().add_child(new_bullet)
	get_parent().add_child(new_shell)
	bullet_shot.emit()
	gun_magazine -= 1
	if powered_up:
		hud.update_bullets(str(gun_magazine, "/", gun_magazine_capacity, " x ", mags))
	else:
		AudioManager.play_sfx(gun_sound, -5)
		hud.update_bullets(str(gun_magazine, "/", gun_magazine_capacity, " x ∞"))
	#print("mag", gun_magazine)
	if gun_magazine == 0:
		no_ammo.emit()
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
	AudioManager.play_sfx(in_between_shot_sound, -5)
	pass # Replace with function body.


func _on_final_timer_timeout():
	AudioManager.play_sfx(final_shot_sound)
	pass # Replace with function body.
