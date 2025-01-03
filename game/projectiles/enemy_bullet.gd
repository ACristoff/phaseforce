extends Area2D

@export var speed: int = 350


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta
	if self.has_overlapping_bodies():
		var all_bodies = self.get_overlapping_bodies()
		for body in all_bodies:
			if body is BasePlayer:
				#print("hit player!")
				body.take_damage()
				queue_free()
			if body is MetalGround || body is SnowGround:
				queue_free()
