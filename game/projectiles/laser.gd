extends CharacterBody2D

#extends Bullet

@onready var ray = $RayCast2D

@export var speed = 500
var damage = 50
#@onready var collision = 
var pierce = 0
var enemy_stack = []
@onready var hitbox: Area2D= $Hitbox
@onready var bounce_timer = $BounceTimer

var bounced = false
var bounced_vector 

func inverse_angle(delta, body):
	var normie = ray.get_collision_normal()
	var new_angle = Vector2(transform.x * speed).bounce(normie)
	return new_angle

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

func _physics_process(delta):
	if !bounced_vector:
		position += transform.x * speed * delta
	else:
		position += bounced_vector * delta
	
	if hitbox.has_overlapping_areas():
		var all_areas = hitbox.get_overlapping_areas()
		for area in all_areas:
			if area is Shield:
				self.monitoring = false
				var enemy: ShieldEnemy = area.get_parent()
				enemy.shield_take_damage(damage)
				queue_free()
	if hitbox.has_overlapping_bodies():
		var all_bodies = hitbox.get_overlapping_bodies()
		for body in all_bodies:
			if body is BasePlayer:
				return
			if body is SnowGround:
				if bounced_vector && bounced == true:
					queue_free()
				if bounce_timer.is_stopped():
					bounce_timer.start()
				bounced_vector = inverse_angle(delta, body)
				body.emit(self.global_position)
			elif body is MetalGround && bounced == true:
				if bounced_vector:
					queue_free()
				bounced_vector = inverse_angle(delta, body)
				if bounce_timer.is_stopped():
					bounce_timer.start()
				body.emit(self.global_position)
			elif body is Door:
				if bounced_vector && bounced == true:
					queue_free()
				if bounce_timer.is_stopped():
					bounce_timer.start()
				bounced_vector = inverse_angle(delta, body)
			elif body is Generator:
				body.emit(self.global_position)
				queue_free()
			elif body is EnemyBase:
				apply_damage(body, false)
				queue_free()
	move_and_slide()


func _on_bounce_timer_timeout():
	bounced = true
	pass # Replace with function body.
