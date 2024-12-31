extends Area2D

@export var speed = 600

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta
	pass

func _on_area_entered(_area):
	#print(area)
	#if area is BasePlayer:
		#return
	queue_free()
	pass # Replace with function body.

func _on_body_entered(body):
	if body is BasePlayer:
		return
	if body is SnowGround:
		body.emit(self.global_position)
		queue_free()
	elif body is MetalGround:
		body.emit(self.global_position)
		queue_free()
	#queue_free()
