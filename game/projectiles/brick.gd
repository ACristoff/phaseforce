extends Area2D

class_name Brick

@export var speed = 500
var damage = 50
#var throw = -300
#var brick_gravity = 500
var new_grav = 0
var accelerate = 10

@onready var brick_hit = preload("res://assets/sfx/projectiles/BRICK_HIT.mp3")

func _physics_process(delta):
	new_grav += accelerate * delta
	position += Vector2(Vector2(transform.x * speed * delta).x, Vector2(transform.x * speed * delta).y + new_grav)
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
				AudioManager.play_sfx(brick_hit)
				body.emit(self.global_position)
				queue_free()
			elif body is MetalGround:
				AudioManager.play_sfx(brick_hit)
				body.emit(self.global_position)
				queue_free()
			elif body is Generator:
				AudioManager.play_sfx(brick_hit)
				body.emit(self.global_position)
				queue_free()
			elif body is EnemyBase:
				AudioManager.play_sfx(brick_hit)
				print('bullet hits enemy')
				body.take_damage(damage)
				queue_free()
