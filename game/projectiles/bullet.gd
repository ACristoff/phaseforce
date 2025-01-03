extends Area2D

class_name Bullet

@export var speed = 500
var damage = 50

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#position += transform.x * speed * delta
	##if self.
	#pass

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_area_entered(_area):
	#prints('area: ',_area)
	#if area is BasePlayer:
		#return
	queue_free()
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
	#queue_free()
