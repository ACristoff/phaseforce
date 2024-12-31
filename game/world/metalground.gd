extends TileMapLayer

#This could be better planned but we're 6 days out now
class_name MetalGround

@onready var PARTICLE = preload("res://game/projectiles/hit_particles.tscn")

func emit(position):
	print(position)
	pass
