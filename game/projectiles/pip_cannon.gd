extends Area2D

@export var speed = 500
var damage = 50

@onready var arty = $Sprite2D
@onready var explosion = $Explosion
@onready var anim = $AnimationPlayer
@onready var explosion_sound
var active: bool = true

func _ready():
	arty.visible = true
	pass

func _physics_process(delta):
	if active:
		position += transform.x * speed * delta

func _on_area_entered(_area):
	if _area is BasePlayer:
		return

func randomize_rotate():
	var random_angle = randi_range(0,364)
	rotation_degrees = random_angle

func _on_body_entered(body):
	#prints('body: ',body)
	if body is BasePlayer:
		return
	if body is SnowGround:
		body.emit(self.global_position)
		anim.play("explosion")
		randomize_rotate()
		#explosion.visible = true
		#queue_free()
	elif body is MetalGround:
		body.emit(self.global_position)
		anim.play("explosion")
		randomize_rotate()
		#explosion.visible = true
		#queue_free()
	elif body is Generator:
		body.emit(self.global_position)
		anim.play("explosion")
		randomize_rotate()
		#explosion.visible = true
		#queue_free()
	elif body is EnemyBase:
		body.take_damage(damage)
		anim.play("explosion")
		randomize_rotate()
		#explosion.visible = true
		#queue_free()
	active = false
	#elif body is Door:
		#queue_free()
	#queue_free()

func _explode():
	print('expplode')
	pass

func _kill_myself():
	print('die')
	queue_free()
	pass
