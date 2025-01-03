extends StaticBody2D

class_name Generator

var shake_amount = 1
var destroyed = false
@onready var graphic = $Sprite2D
@onready var debris = $GPUParticles2D
@onready var PARTICLE = preload("res://game/projectiles/bullet_hit_particle.tscn")

@export var doors_to_unlock: Array[Door] = []

signal just_destroyed

func _ready():
	#randomize()
	pass

func emit(emit_position):
	#print('yipee', emit_position)
	var particle = PARTICLE.instantiate()
	particle.global_position = emit_position
	particle.type = 2
	get_tree().current_scene.add_child(particle)
	destroy()

func destroy():
	if destroyed == false:
		emit_signal("just_destroyed")
		destroyed = true
		graphic.visible = false
		debris.emitting = true
		if doors_to_unlock.size() > 0:
			for door in doors_to_unlock:
				door.distant_open()
		queue_free()
	else:
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	graphic.offset = Vector2(randi_range(-1, 1) * shake_amount, randi_range(-1, 1) * shake_amount)


func _on_gpu_particles_2d_finished():
	queue_free()
