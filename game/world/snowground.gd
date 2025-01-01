extends TileMapLayer

class_name SnowGround

@onready var PARTICLE = preload("res://game/projectiles/bullet_hit_particle.tscn")

func emit(emit_position):
	#print('yipee', emit_position)
	var particle = PARTICLE.instantiate()
	particle.global_position = emit_position
	particle.type = 1
	get_tree().current_scene.add_child(particle)
