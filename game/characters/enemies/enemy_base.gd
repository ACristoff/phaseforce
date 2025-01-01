extends CharacterBody2D

class_name EnemyBase

@onready var idle_timer = $Timers/IdleTimer
@onready var walk_timer = $Timers/WalkTimer
@onready var anim = $AnimationPlayer
@onready var scan_zone = $ScanArea

enum ENEMY_STATES {IDLE, IDLEWALK, ALERTED}
@export var speed: int = 50
var enemy_state: ENEMY_STATES = ENEMY_STATES.IDLE
var alert: bool = false
var health: int = 100



# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func die():
	
	pass

func _physics_process(delta):
	
	if enemy_state == ENEMY_STATES.IDLE && idle_timer.is_stopped():
		idle()
	
	#Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

func track_player():
	
	pass

func attack():
	
	pass

func idle_walk_to(distance):
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
	pass

func _on_idle_timer_timeout():
	var direction = randi_range(-5, 5)
	idle_walk_to(direction)

func _on_walk_timer_timeout():
	velocity.x = 0
	idle()

	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	#move_and_slide()
