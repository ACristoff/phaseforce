extends TileMapLayer

#This could be better planned but we're 6 days out now
class_name MetalGround

@onready var PARTICLE = preload("res://game/projectiles/bullet_hit_particle.tscn")

func emit(emit_position):
	#print('yipee', emit_position)
	var particle = PARTICLE.instantiate()
	particle.global_position = emit_position
	particle.type = 2
	get_tree().current_scene.add_child(particle)
