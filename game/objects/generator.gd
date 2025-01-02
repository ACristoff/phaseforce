extends StaticBody2D

class_name Generator

var shake_amount = 1
var destroyed = false
@onready var graphic = $Sprite2D
@onready var debris = $GPUParticles2D
@onready var PARTICLE = preload("res://game/projectiles/bullet_hit_particle.tscn")
# Called when the node enters the scene tree for the first time.

signal just_destroyed

func _ready():
	randomize()

func emit(emit_position):
	destroy()
	#print('yipee', emit_position)
	var particle = PARTICLE.instantiate()
	particle.global_position = emit_position
	particle.type = 2
	get_tree().current_scene.add_child(particle)

func destroy():
	if destroyed == false:
		emit_signal("just_destroyed")
		destroyed = true
		graphic.visible = false
		debris.emitting = true
	else:
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	graphic.offset = Vector2(randi_range(-1, 1) * shake_amount, randi_range(-1, 1) * shake_amount)
