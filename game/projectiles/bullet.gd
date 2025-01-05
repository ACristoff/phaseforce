extends Area2D

class_name Bullet

@export var speed = 500
var damage = 50
#@onready var collision = 
var pierce = 0
var enemy_stack = []

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
				apply_damage(body, false)

func apply_damage(body, shield):
	pierce -= 1
	if enemy_stack.has(body):
		return
	if !shield:
		enemy_stack.append(body)
		body.take_damage(damage)
	elif shield:
		body.shield_take_damage(damage)
	if pierce < 0:
		queue_free()
	pass 
