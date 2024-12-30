extends TileMapLayer

class_name SnowGround

#@onready var PARTICLE = preload("res://game/projectiles/hit_particles.tscn")
#@onready var PARTICLE = preload("res://assets/particles/hit_particles_debug.tscn")
#@onready var PARTICLE = preload("res://game/projectiles/basic_particle.tscn")
#@onready var PARTICLE = preload("res://game/projectiles/basic_particle.tscn")
#
#func emit(emit_position):
	#print('yipee', emit_position)
	#var particle = PARTICLE.instantiate()
	#particle.global_position = emit_position
	#get_tree().current_scene.add_child(particle)
	#
	##particle.type = 1
	#pass

#func _on_body_entered(body):
	#if body.has_method("metal"):
		#print("hit metal tile")
		#
	#elif body.has_method("snow"):
		#var particle = PARTICLE.instantiate()
		#get_tree().current_scene.add_child(particle)
		##particle.global_position = $".".global_position
		#particle.type = 1
		#print("hit snow tile")
		#queue_free()
