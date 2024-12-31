extends CharacterBody2D

class_name EnemyBase

@onready var idle_timer = $Timers/IdleTimer
@onready var anim = $AnimationPlayer

enum ENEMY_STATES {IDLE, IDLEWALK, ALERTED}
var enemy_state: ENEMY_STATES = ENEMY_STATES.IDLE
var alert: bool = false



# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func _physics_process(delta):
	
	if enemy_state == ENEMY_STATES.IDLE && idle_timer.is_stopped():
		idle(delta)
	
	#Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

func track_player():
	
	pass

func attack():
	
	pass

func idle(_delta):
	anim.play("idle")
	idle_timer.start()
	pass

func _on_idle_timer_timeout():
	#print('finish idle')
	
	pass # Replace with function body.


#func _physics_process(delta):
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
