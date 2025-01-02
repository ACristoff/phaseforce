extends CharacterBody2D

class_name EnemyBase

@onready var idle_timer: Timer = $Timers/IdleTimer
@onready var walk_timer: Timer = $Timers/WalkTimer
@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var scan_zone = $ScanArea
@onready var floor_cast = $RayCast2D
@onready var wall_cast = $WallCast
@onready var collision = $CollisionShape2D
@onready var gun = $Gun
@onready var alert_label: Label = $AlertLabel

enum ENEMY_STATES {IDLE, IDLEWALK, ALERTED}
@export var speed: int = 50
var enemy_state: ENEMY_STATES = ENEMY_STATES.IDLE
var alert: bool = false
var health: int = 100
var facing_right: bool = true
var player: BasePlayer

signal snowman_death

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func die():
	snowman_death.emit()
	queue_free()

func take_damage(damage):
	health -= damage

func _physics_process(delta):
	if health <= 0:
		die()
		pass
	
	if enemy_state == ENEMY_STATES.IDLE && idle_timer.is_stopped():
		idle()
	
	if enemy_state == ENEMY_STATES.IDLEWALK:
		if !check_for_floor() && velocity.x != 0:
			#print("stop")
			velocity.x = 0
			walk_away_from_edge()
		if check_for_wall() && walk_timer.time_left < 1:
			velocity.x = 0
			turn(!facing_right)
		elif check_for_wall():
			velocity.x = -velocity.x
			turn(!facing_right)
	
	#Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

func check_for_floor():
	if floor_cast.is_colliding():
		return true
	else:
		return false

func check_for_wall():
	if wall_cast.is_colliding():
		return true
	else:
		return false

func track_player():
	
	pass

func attack():
	
	pass

func go_to_alert(entity):
	print("alerted!")
	alert_label.visible = true
	if entity is BasePlayer:
		player = entity

func turn(direction):
	facing_right = direction
	if direction:
		sprite.flip_h = false
		floor_cast.position.x = 10
		wall_cast.scale.x = 1
		scan_zone.scale.x = 1
		gun.scale.x = 1
	else:
		sprite.flip_h = true
		floor_cast.position.x = -10
		wall_cast.scale.x = -1
		scan_zone.scale.x = -1
		gun.scale.x = -1

func idle_walk_to(distance):
	if distance < 0:
		turn(false)
	elif distance > 0:
		turn(true)
	enemy_state = ENEMY_STATES.IDLEWALK
	if distance < 0:
		velocity.x = -speed
		walk_timer.wait_time = distance * -1
	else:
		velocity.x = speed
		walk_timer.wait_time = distance
	walk_timer.start()

func idle():
	anim.play("idle")
	idle_timer.start()

func choose_walk():
	var direction = randi_range(-5, 5)
	if direction == 0:
		return choose_walk()
	if direction > 0 && !check_for_floor():
		direction = direction * -1
	idle_walk_to(direction)

func walk_away_from_edge():
	walk_timer.stop()
	if facing_right:
		var distance = randi_range(-1, -5)
		turn(false)
		idle_walk_to(distance)
	else:
		var distance = randi_range(1, 5)
		turn(false)
		idle_walk_to(distance)

func idle_then_walk_away():
	walk_timer.stop()
	await get_tree().create_timer(1.0).timeout
	if facing_right:
		var distance = randi_range(-1, -4)
		turn(false)
		idle_walk_to(distance)
	else:
		var distance = randi_range(1, 4)
		turn(false)
		idle_walk_to(distance)
	pass

func _on_idle_timer_timeout():
	if floor_cast.is_colliding():
		choose_walk()

func _on_walk_timer_timeout():
	velocity.x = 0
	idle()

func _on_alert_timer_timeout():
	velocity.x = 0
	idle()
	pass # Replace with function body.

func _on_scan_area_area_entered(area):
	if area is Bullet:
		#print('noticed bullet')
		if enemy_state == ENEMY_STATES.IDLE || enemy_state == ENEMY_STATES.IDLEWALK:
			go_to_alert(area)

func _on_scan_area_body_entered(body):
	if body is BasePlayer:
		if enemy_state == ENEMY_STATES.IDLE || enemy_state == ENEMY_STATES.IDLEWALK:
			go_to_alert(body)
