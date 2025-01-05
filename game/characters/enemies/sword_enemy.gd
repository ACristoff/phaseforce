extends EnemyBase

@onready var enemy_blade_sound = preload("res://assets/sfx/characters/PF_ENEMY_HURT.mp3")
@onready var sword_hit_box = $SwordHitBox
@onready var jump_timer = $Timers/JumpTimer

@export var jump_force = -280.0
var is_jumping = false

func _physics_process(delta):
	if health <= 0:
		die()
		pass
	
	if enemy_state == ENEMY_STATES.IDLE && idle_timer.is_stopped():
		idle()
	
	if enemy_state == ENEMY_STATES.IDLEWALK:
		if !check_for_floor() && velocity.x != 0:
			velocity.x = 0
			walk_away_from_edge()
		if check_for_wall() && walk_timer.time_left < 1:
			velocity.x = 0
			turn(!facing_right)
		elif check_for_wall():
			velocity.x = -velocity.x
			turn(!facing_right)
	
	if enemy_state == ENEMY_STATES.ALERTED:
		var from_to = player.global_position - global_position
		if from_to.x < 0:
			from_to.x = from_to.x * -1
		if from_to.y < 0:
			from_to.y = from_to.y * -1
		if from_to.x < max_sight_distance && from_to.y < max_sight_distance:
			var player_pos = to_local(player.global_position)
			player_cast.target_position = player_pos + Vector2(0, 15)
		check_for_sight()
		#I sense or see the player
		if senses_player || sees_player:
			last_known_position = player.global_position
			if last_known_position.x > global_position.x && !facing_right:
				turn(true)
			elif last_known_position.x < global_position.x && facing_right:
				turn(false)
			if !alert_timer.is_stopped():
				alert_timer.stop()
			if is_searching:
				is_searching = false
				velocity.x = 0
			if sees_player:
				if jump_timer.is_stopped():
					jump_timer.start()
				gun_sprite.look_at(player.global_position)
				var attack_viability = check_attack_distance()
				print(attack_viability)
				if !attack_viability && !attack_timer.is_stopped():
					attack_timer.stop()
				elif attack_viability == "in range" && attack_timer.is_stopped():
					#velocity.x = 0
					run_to_player()
					attack_timer.start()
				if attack_viability == "ideal":
					velocity.x = 0
				if !attack_viability:
					run_to_player()
			else:
				if jump_timer.is_stopped():
					jump_timer.start()
		else:
			if !jump_timer.is_stopped():
				jump_timer.stop()
		if !senses_player && !sees_player && alert_timer.is_stopped():
			alert_timer.start()
			if !is_searching:
				is_searching = true
				move_to_last_known()
		if !check_for_floor() && velocity.x != 0 && !is_jumping:
			velocity.x = 0
	#Add the gravity
	if not is_on_floor():
		is_jumping = true
		velocity += get_gravity() * delta
	move_and_slide()

func idle():
	super()
	attack_timer.wait_time = 0.5

func turn(direction):
	facing_right = direction
	if direction:
		sprite.flip_h = false
		floor_cast.position.x = 10
		wall_cast.scale.x = 1
		scan_zone.scale.x = 1
		gun.scale.x = 1
		gun_barrel.position.x = 19
		sprite.position.x = 4
		sword_hit_box.scale.x = 1
	else:
		sprite.position.x = -4
		sprite.flip_h = true
		floor_cast.position.x = -10
		wall_cast.scale.x = -1
		scan_zone.scale.x = -1
		gun.scale.x = -1
		gun_barrel.position.x = -17
		sword_hit_box.scale.x = -1

func jump():
	
	#print("jump!")
	velocity.y = jump_force
	run_to_player()
	pass

func is_player_y_diff():
	#print('checking player diff on y', player.global_position, global_position)
	
	if player.global_position.y < global_position.y - 20:
		jump()
	else:
		#print("not high enough")
		pass
	pass

func attack():
	#print('shoot')
	attack_timer.wait_time = 1
	AudioManager.play_sfx(enemy_blade_sound)
	anim.play("stab")
	var bodies = sword_hit_box.get_overlapping_bodies()
	for body in bodies:
		if body is BasePlayer:
			var new_body: BasePlayer = body
			new_body.take_damage()

func run_to_player():
	if player.global_position.x > global_position.x:
		anim.play("move")
		velocity.x = speed 
	else:
		anim.play("move")
		velocity.x = -speed 

func run_to_player_delta(delta):
	
	var distance = player.global_position.x - global_position.x
	var max_close = 50
	if distance < 0:
		distance = distance * -1
	#prints(player.global_position.x, global_position.x, distance, distance < max_close )
	if player.global_position.x > global_position.x:
		anim.play("move")
		if distance < max_close:
			#velocity.x = 0
			pass
		else:
			velocity.x += speed * delta
	else:
		anim.play("move")
		if distance < max_close:
			#velocity.x = 0
			pass
		else:
			velocity.x += -speed * delta
		pass

func move_to_last_known():
	if last_known_position.x > global_position.x:
		velocity.x = speed
	else:
		velocity.x = -speed


func _on_jump_timer_timeout():
	is_player_y_diff()
