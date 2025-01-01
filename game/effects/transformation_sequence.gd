extends Node2D

var type = 1
@onready var anim = $AnimationPlayer

func begin():
	if type == 1:
		self.modulate = Color.AQUAMARINE
	elif type == 2:
		self.modulate = Color.SLATE_BLUE
	elif type == 3:
		self.modulate = Color.PLUM
	elif type ==4:
		self.modulate = Color.PINK
	else:
		self.modulate = Color.LIGHT_GOLDENROD
	anim.play("transform")
	
func _on_gpu_particles_2d_finished():
	queue_free()
