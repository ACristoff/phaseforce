extends Area2D

@export var speed = 500
var damage = 50

@onready var explosion = $Explosion
@onready var anim = $AnimationPlayer
@onready var explosion_sound

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_area_entered(_area):
	if _area is BasePlayer:
		return
	pass # Replace with function body.

func _on_body_entered(body):
	#prints('body: ',body)
	if body is BasePlayer:
		return
	if body is SnowGround:
		body.emit(self.global_position)
		queue_free()
	elif body is MetalGround:
		body.emit(self.global_position)
		queue_free()
	elif body is Generator:
		body.emit(self.global_position)
		queue_free()
	elif body is EnemyBase:
		body.take_damage(damage)
		queue_free()
	#elif body is Door:
		#queue_free()
	queue_free()

func _explode():
	pass

func _kill_myself():
	pass
