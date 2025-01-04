extends BasePlayer


var knockback_force = -1
var powered_knockback_force = -5
@onready var TRANSEFFECT = preload("res://game/effects/transformation_sequence.tscn")
@onready var pip_rocket = preload("res://game/projectiles/pip_cannon.tscn")

func attack():
	gun_anim.stop()
	gun_anim.play("kickback")
	if !powered_up:
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
	else:
		##TODO pipcannon here
		var new_rocket = pip_rocket.instantiate()
		#var new_shell
		new_rocket.damage = bullet_damage
		new_rocket.speed = bullet_speed
		new_rocket.global_position = cursor_spout.global_position
		var adjusted_angle = cursor.rotation_degrees + randi_range(gun_spread[0],gun_spread[1])
		new_rocket.rotation_degrees = adjusted_angle
		get_parent().add_child(new_rocket)
	bullet_shot.emit()
	gun_magazine -= 1
	if powered_up:
		hud.update_bullets(str(gun_magazine, "/", gun_magazine_capacity, " x ", mags))
	else:
		hud.update_bullets(str(gun_magazine, "/", gun_magazine_capacity, " x ∞"))
	if gun_magazine == 0:
		no_ammo.emit()
	if !powered_up:
		var knockback_vector = (cursor_spout.global_position - global_position) * knockback_force
		knockback = knockback_vector * 2
	else:
		var knockback_vector = (cursor_spout.global_position - global_position) * powered_knockback_force
		if knockback_vector.y < 0:
			velocity.y = knockback_vector.y * 4
		else:
			knockback_vector.y = knockback_vector.y - 40
			if knockback_vector.y < 0:
				velocity.y = knockback_vector.y * 4
			velocity.y = knockback_vector.y - 30
		knockback = knockback_vector * 4

func power_up():
	super()
	var trans = TRANSEFFECT.instantiate()
	self.add_child(trans)
	trans.type = 1
	trans.begin()
	trans.global_position = self.global_position



#func attack() -> void:
	#gun_anim.stop()
	#gun_anim.play("kickback")
	#if !powered_up:
		#var new_brick = brick_projectile.instantiate()
		#new_brick.damage = bullet_damage
		#new_brick.speed = bullet_speed
		#new_brick.global_position = cursor_spout.global_position
		#var adjusted_angle = cursor.rotation_degrees + randi_range(gun_spread[0],gun_spread[1])
		#new_brick.rotation_degrees = adjusted_angle
		#get_parent().add_child(new_brick)
	#else:
		#var new_shell = shell.instantiate()
		#new_shell.global_position = shell_spout.global_position
		#get_parent().add_child(new_shell)
		#for pellets in shotgun_pellet_count:
			#var new_bullet = bullet.instantiate()
			#new_bullet.damage = bullet_damage
			#new_bullet.speed = bullet_speed
			#new_bullet.global_position = cursor_spout.global_position
			#var adjusted_angle = cursor.rotation_degrees + randi_range(gun_spread[0],gun_spread[1])
			#new_bullet.rotation_degrees = adjusted_angle
			#get_parent().add_child(new_bullet)
	#bullet_shot.emit()
	#gun_magazine -= 1
	#if powered_up:
		#hud.update_bullets(str(gun_magazine, "/", gun_magazine_capacity, " x ", mags))
	#else:
		#hud.update_bullets(str(gun_magazine, "/", gun_magazine_capacity, " x ∞"))
	#if gun_magazine == 0:
		#no_ammo.emit()
	#if powered_up:
		#var knockback_vector = (cursor_spout.global_position - global_position) * knockback_force
		#if knockback_vector.y < 0:
			#velocity.y = knockback_vector.y * 4
		#else:
			#knockback_vector.y = knockback_vector.y - 40
			#if knockback_vector.y < 0:
				#velocity.y = knockback_vector.y * 4
			#velocity.y = knockback_vector.y - 30
		#knockback = knockback_vector * 3
	#else:
		#start_reload()
#
#func reload():
	#gun_magazine = gun_magazine_capacity
	#if powered_up:
		#AudioManager.play_sfx(reload_sound)
		#mags -= 1
		#hud.update_bullets(str(gun_magazine, "/", gun_magazine_capacity, " x ", mags))
	#else:
		#hud.update_bullets(str(gun_magazine, "/", gun_magazine_capacity, " x ∞"))
#
#func power_up():
	#super()
	#var trans = TRANSEFFECT.instantiate()
	#self.add_child(trans)
	#trans.type = 3
	#trans.begin()
	#trans.global_position = self.global_position
