extends CharacterBody2D
class_name BasePlayer

@onready var sprite: Sprite2D = $Sprite2D
@onready var camera: Camera2D = $Camera2D
@onready var cursor = $AttackCursor
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var attack_timer: Timer = $Timers/AttackTimer
@onready var cooldown_timer: Timer = $Timers/CooldownTimer
@onready var invul_timer: Timer = $Timers/InvulTimer

@export var JUMP_VELOCITY = -400.0
@export var SPEED: float = 300.0
var ATTACK: int = 8
var ATTACK_SPEED: float = 1.2
var HEALTH: int = 20

var face_right: bool = true
var attack_direction 

func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	#TODO Add case for controller related input
	if event is InputEventMouse:
		update_cursor(event)
	pass

func _physics_process(delta: float) -> void:
	##ACTIONS
	if Input.is_action_just_pressed("shoot"):
		attack()
		pass
	
	##PLAYER MOVEMENT##
	#Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var horizontalDirection = Input.get_axis("move_left", "move_right")
	#Flip the sprite whether moving left or right
	if horizontalDirection:
		anim_player.play("Run")
		sprite.flip_h = (horizontalDirection == -1)
		face_right = (horizontalDirection == 1)
	velocity.x = horizontalDirection * SPEED
	#velocity = velocity.normalized() * min(velocity.length(), SPEED)
	#Idle
	if velocity.x == 0 and velocity.y == 0:
		anim_player.play("Idle")
		pass
	move_and_slide()

func attack() -> void:
	prints('ATTACKO', attack_direction)
	pass


#TODO Split out the attack cursor as its own node?
func update_cursor(event):
	#Get mouse cursor relative to player
	#Smoothly rotate the aiming cursor towards mouse
	#Update attack_direction var
	
	#TODO create a case for controller input, right stick angle
	cursor.look_at(get_global_mouse_position())
	#Gonna have to fix this but I think it works as a radian
	attack_direction = cursor.rotation
	#TODO smoothing by updating attack direction and instead moving the cursor to look at in update
	pass
