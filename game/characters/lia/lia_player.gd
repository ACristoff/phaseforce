extends BasePlayer


var knockback_force = -4
@onready var TRANSEFFECT = preload("res://game/effects/transformation_sequence.tscn")
var charge = 0
var charge_cap = 21
var charge_rate = 8
var current_shot: EnergyBall

@onready var charge_shot = preload("res://game/projectiles/charge_shot.tscn")
@onready var sound_player = $AudioStreamPlayer2D
@onready var first_sound = preload("res://assets/sfx/projectiles/DATA_CANNON_FIRST.mp3")
@onready var middle_sound = preload("res://assets/sfx/projectiles/DATA_CANNON_MIDDLE.mp3")
@onready var last_sound = preload("res://assets/sfx/projectiles/DATA_CANNON_LAST.mp3")

func attack():
	AudioManager.play_sfx(gun_sound)
	gun_anim.stop()
	gun_anim.play("kickback")
	if powered_up:
		#var new_shot = charge_shot.instantiate()
		pass
	else:
		muzzle_flash.play("muzzlef")
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
		hud.update_bullets(str(gun_magazine, "/", gun_magazine_capacity, " x ∞"))
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
	else:
		var adjusted_knockback_force = knockback_force * (charge / 2)
		#prints(knockback_force, charge, adjusted_knockback_force)
		var knockback_vector = (cursor_spout.global_position - global_position) * adjusted_knockback_force
		if knockback_vector.y < 0:
			velocity.y = knockback_vector.y
		else:
			knockback_vector.y = knockback_vector.y - 40
			if knockback_vector.y < 0:
				velocity.y = knockback_vector.y
			velocity.y = knockback_vector.y - 30
		knockback = knockback_vector * 3


func _physics_process(delta: float) -> void:
	if is_active == false:
		##print('I AM MENTALLY DISABLED')
		velocity = Vector2.ZERO
		return
	mouse_cursor.position = get_local_mouse_position()
	if health == 0:
		player_death.emit()
		health = -1
	
	if extract != null:
		arrow.look_at(extract.global_position)
	##ACTIONS
	debug_text.text = str(attack_direction)
	if powered_up:
		if current_shot && charge > 0:
			current_shot.global_position = cursor_spout.global_position
			var calculated_frame = int((charge / charge_cap) * 6) 
			var shot_sprite: Sprite2D = current_shot.sprite
			shot_sprite.frame = calculated_frame
		if Input.is_action_just_pressed("shoot"):
			AudioManager.play_sfx(first_sound)
			var new_charge: EnergyBall = charge_shot.instantiate()
			new_charge.global_position = cursor_spout.global_position
			current_shot = new_charge
			get_parent().add_child(new_charge)
		if Input.is_action_pressed("shoot"):
			if charge <= charge_cap:
				charge += charge_rate * delta
				cursor_sprite.value = charge + 9
			if charge < 15 && sound_player.stream != middle_sound:
				sound_player.stream = middle_sound
		if Input.is_action_just_released("shoot") && charge > 5:
			#print("")
			sound_player.stop()
			var charge_sound_adjust = -20 + charge
			AudioManager.play_sfx(last_sound, charge_sound_adjust )
			var adjusted_angle = cursor.rotation_degrees + randi_range(gun_spread[0],gun_spread[1])
			current_shot.rotation_degrees = adjusted_angle
			current_shot.damage = powered_up_damage * charge
			#prints(current_shot.damage, powered_up_damage, charge)
			attack()
			charge = 0
			cursor_sprite.value = charge + 9
			current_shot.release_shot()
			current_shot = null
		elif Input.is_action_just_released("shoot"):
			charge = 0
			cursor_sprite.value = charge + 9
			current_shot.queue_free()
			current_shot = null

	else:
		if Input.is_action_pressed("shoot") && attack_timer.is_stopped():
			if reload_timer.is_stopped() && gun_magazine > 0:
				attack_timer.start()
				#AudioManager.play_sfx(gun_sound)
				attack()
		if Input.is_action_just_pressed("shoot") && gun_magazine <= 0:
			AudioManager.play_sfx(empty_mag_sound, 5)
			start_reload(true)
		if Input.is_action_just_pressed("reload"):
			if powered_up:
				if mags > 0:
					start_reload()
			else:
				start_reload()
	if Input.is_action_just_pressed("interact") && current_door:
		if current_door.closed:
			current_door.open()

	##PLAYER MOVEMENT##
	#Add the gravity.
	if not is_on_floor() && !is_ladder():
		velocity += get_gravity() * delta
		coyote_timer -= 1 * delta
	#Jump Buffering
	if Input.is_action_just_pressed("jump") && !is_on_floor() && jump_buffer_timer.is_stopped():
		jump_buffer_timer.start()
	if !jump_buffer_timer.is_stopped() && is_on_floor():
		jump(JUMP_VELOCITY)
	
	#Coyote Time and Jumping
	if Input.is_action_just_pressed("jump") && coyote_timer > 0:
		jump(JUMP_VELOCITY)
	if is_on_floor() && !Input.is_action_just_pressed("jump") && coyote_timer != coyote_time:
		if jump_buffer_timer.is_stopped():
			coyote_timer = coyote_time
	var horizontalDirection = Input.get_axis("move_left", "move_right")
	#Flip the sprite whether moving left or right
	if horizontalDirection:
		#anim_player.play("Run")
		change_animation("Run")
		sprite.flip_h = (horizontalDirection == -1)
		face_right = (horizontalDirection == 1)
		door_detector.scale.x = horizontalDirection
		##Footsteps
		if is_on_floor() && step_timer.is_stopped():
			step_timer.start()
			var random = randi_range(0,3)
			AudioManager.play_sfx(steps[random], -15)
	velocity.x = horizontalDirection * SPEED + knockback.x
	if knockback.x != 0:
		knockback = lerp(knockback, Vector2.ZERO, 0.1)
	if knockback.x < 1 && knockback.x > -1:
		knockback = Vector2.ZERO
	
	if floor_cast.is_colliding():
		if is_ladder():
			if Input.is_action_pressed("move_up") or Input.is_action_pressed("jump"):
				velocity.y = -SPEED
			elif Input.is_action_pressed("move_down"):
				velocity.y = SPEED
				pass
			else:
				velocity.y = 0
	if current_platform_stack.size() > 0:
		if Input.is_action_pressed("move_down"):
			for platform in current_platform_stack:	
				platform.disable_platform()
		elif Input.is_action_just_released("move_down"):
			for platform in current_platform_stack:
				platform.enable_platform()
	if powered_up && gun_magazine == 0 && mags <= 0:
		power_down()
	#Idle
	if velocity == Vector2(0,0) or velocity == Vector2.ZERO:
		#anim_player.play("Idle")
		change_animation("Idle")
	move_and_slide()

func power_up():
	super()
	var trans = TRANSEFFECT.instantiate()
	self.add_child(trans)
	trans.type = 2
	trans.begin()
	trans.global_position = self.global_position
