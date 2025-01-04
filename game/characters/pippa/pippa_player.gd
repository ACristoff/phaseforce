extends BasePlayer


var knockback_force = -1
var powered_knockback_force = -5
@onready var TRANSEFFECT = preload("res://game/effects/transformation_sequence.tscn")

func attack():
	super()
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
		knockback = knockback_vector * 3

func power_up():
	super()
	var trans = TRANSEFFECT.instantiate()
	self.add_child(trans)
	trans.type = 1
	trans.begin()
	trans.global_position = self.global_position
