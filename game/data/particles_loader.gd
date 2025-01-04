extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$BulletHitParticle.emitting = true
	$GPUParticles2D.emitting = true
	$SpentShell.emitting = true
	$GPUParticles2D2.emitting = true
