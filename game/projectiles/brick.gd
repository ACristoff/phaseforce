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
	#position += transform.x * speed * delta
	#brick_gravity += strength
	#throw += brick_gravity * delta
	#var test = Vector2(Vector2(transform.x * speed * delta).x, Vector2(transform.y * throw * delta).y  * speed)
	#position += test
	#position += Vector2(Vector2(transform.x * speed * delta).x, Vector2(transform.x * speed * delta).y * new_grav * delta)
	position += Vector2(Vector2(transform.x * speed * delta).x, Vector2(transform.x * speed * delta).y + new_grav)
	#position.y += 100 * delta
	#print(gravity * delta)
	pass

func _on_area_entered(_area):
	if _area is BasePlayer:
		return
	pass # Replace with function body.

func _on_body_entered(body):
	#prints('body: ',body)
	if body is BasePlayer:
		return
	if body is SnowGround:
		AudioManager.play_sfx(brick_hit, -10)
		body.emit(self.global_position)
		queue_free()
	elif body is MetalGround:
		AudioManager.play_sfx(brick_hit, -10)
		body.emit(self.global_position)
		queue_free()
	elif body is Generator:
		AudioManager.play_sfx(brick_hit, -10)
		body.emit(self.global_position)
		queue_free()
	elif body is EnemyBase:
		AudioManager.play_sfx(brick_hit, -10)
		body.take_damage(damage)
		queue_free()
	AudioManager.play_sfx(brick_hit, -10)
	#elif body is Door:
		#queue_free()
	queue_free()
