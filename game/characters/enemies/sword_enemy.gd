extends EnemyBase


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
		#do attack here
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
				gun_sprite.look_at(player.global_position)
				var attack_viability = check_attack_distance()
				if !attack_viability && !attack_timer.is_stopped():
					print('attack not viable, stop timer')
					attack_timer.stop()
				elif attack_viability && attack_timer.is_stopped():
					#print('attack viable, start attack timer')
					attack_timer.start()
				if !attack_viability:
					run_to_player()
				#else:
					
				#if check
		if !senses_player && !sees_player && alert_timer.is_stopped():
			alert_timer.start()
			if !is_searching:
				is_searching = true
				move_to_last_known()
		if !check_for_floor() && velocity.x != 0:
			velocity.x = 0
	
	#Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

func run_to_player():
	if player.global_position.x > global_position.x:
		velocity.x = speed
	else:
		velocity.x = -speed
		pass

func move_to_last_known():
	if last_known_position.x > global_position.x:
		velocity.x = speed
	else:
		velocity.x = -speed
	pass
