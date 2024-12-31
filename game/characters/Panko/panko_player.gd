extends BasePlayer

var knockback_force = -2

func attack():
	super()
	if !powered_up:
		var knockback_vector = (cursor_spout.global_position - global_position) * knockback_force
		if knockback_vector.y < 0:
			#print('big jump')
			velocity.y = knockback_vector.y * 4
		else:
			#print('small jump')
			knockback_vector.y = knockback_vector.y - 40
			if knockback_vector.y < 0:
				velocity.y = knockback_vector.y * 4
			velocity.y = knockback_vector.y - 30
			
		knockback = knockback_vector * 3
		#prints('big knockback', knockback_vector)
