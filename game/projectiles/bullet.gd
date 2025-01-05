extends Area2D

class_name Bullet

@export var speed = 500
var damage = 50
#@onready var collision = 

func _physics_process(delta):
	position += transform.x * speed * delta
	if self.has_overlapping_areas():
		var all_areas = self.get_overlapping_areas()
		for area in all_areas:
			if area is Shield:
				self.monitoring = false
				var enemy: ShieldEnemy = area.get_parent()
				enemy.shield_take_damage(damage)
				queue_free()
	if self.has_overlapping_bodies():
		var all_bodies = self.get_overlapping_bodies()
		for body in all_bodies:
			print(body)
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
				print('bullet hits enemy')
				body.take_damage(damage)
				queue_free()
	

func _on_area_entered(_area):
	if _area is BasePlayer:
		return
	pass # Replace with function body.


#
#func _on_body_entered(body):
	##prints('body: ',body)
#
	##elif body is Door:
		##queue_free()
	#queue_free()
