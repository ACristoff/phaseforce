extends Node2D

@onready var particles = $GPUParticles2D
var type = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	particles.emitting = true


func _on_gpu_particles_2d_finished() -> void:
	queue_free()
