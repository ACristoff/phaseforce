extends Area2D

@export var speed = 500
var damage = 50
var explosion_damage = 100

@onready var arty = $Sprite2D
@onready var explosion = $Explosion
@onready var anim = $AnimationPlayer
@onready var explosion_sound
@onready var explosion_radius = $Area2D
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
	arty.rotation_degrees = random_angle

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
	var all_bodies = explosion_radius.get_overlapping_bodies()
	for body in all_bodies:
		var new_body: EnemyBase = body
		new_body.take_damage(explosion_damage)

func _kill_myself():
	#print('die')
	queue_free()
	pass
