extends Area2D

class_name EnergyBall

@export var speed = 500
var damage = 50
var active: bool = false
var shake_amount = 1


@onready var collider = $CollisionShape2D

@onready var sprite = $Sprite2D
@onready var brick_hit = preload("res://assets/sfx/projectiles/BRICK_HIT.mp3")

func _physics_process(delta):
	sprite.offset = Vector2(randi_range(-1, 1) * shake_amount, randi_range(-1, 1) * shake_amount)
	if active:
		position += Vector2(transform.x * speed * delta)

func _ready():
	#collider.disabled = true
	pass

func release_shot():
	#print('released')
	active = true
	#collider.disabled = true
	

func update_frame():
	pass

func _on_area_entered(_area):
	#print(_area)
	if _area is BasePlayer:
		return

func _on_body_entered(body):
	#print(body)
	if body is BasePlayer:
		return
	if body is SnowGround:
		#AudioManager.play_sfx(brick_hit, -10)
		body.emit(self.global_position)
		#queue_free()
	elif body is MetalGround:
		#AudioManager.play_sfx(brick_hit, -10)
		body.emit(self.global_position)
		#queue_free()
	elif body is Generator:
		#AudioManager.play_sfx(brick_hit, -10)
		body.emit(self.global_position)
		#queue_free()
		pass
	elif body is EnemyBase:
		#AudioManager.play_sfx(brick_hit, -10)
		body.take_damage(damage)
	#AudioManager.play_sfx(brick_hit, -10)
