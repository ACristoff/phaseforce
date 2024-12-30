extends CharacterBody2D
class_name BasePlayer

@onready var sprite: Sprite2D = $Sprite2D
@onready var camera: Camera2D = $Camera2D
@onready var cursor = $AttackCursor
@onready var cursor_sprite = $AttackCursor/PankoArm/CursorSprite
@onready var arm = $AttackCursor/PankoArm
@onready var cursor_spout = $AttackCursor/PankoArm/CursorSprite/Marker2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var attack_timer: Timer = $Timers/AttackTimer
@onready var cooldown_timer: Timer = $Timers/CooldownTimer
@onready var step_timer: Timer = $Timers/StepTimer
@onready var invul_timer: Timer = $Timers/InvulTimer
@onready var debug_text: Label = $Label

@onready var steps = [
	preload("res://assets/sfx/misc/SNOW_STEP_1.mp3"), 
	preload("res://assets/sfx/misc/SNOW_STEP_2.mp3"), 
	preload("res://assets/sfx/misc/SNOW_STEP_3.mp3"),
	preload("res://assets/sfx/misc/SNOW_STEP_4.mp3")
]

##TODO Destructurize this
@onready var bullet = preload("res://game/projectiles/bullet.tscn")
var gun_spread = [-1,2]
#@onready var tommy_first = preload("res://assets/sfx/TOMMY GUN ONESHOT_FIRST.mp3")
@onready var tommy_last = preload("res://assets/sfx/projectiles/TOMMY_GUN_ONESHOT_LAST.mp3")

@export var JUMP_VELOCITY = -400.0
@export var SPEED: float = 300.0
var ATTACK: int = 8
#var ATTACK_SPEED: float = 0.07692
var attack_cooldown:float = 0
var HEALTH: int = 20
var powered_up: bool = false

var face_right: bool = true
var attack_direction

#var modulo_direction

func _ready() -> void:
	#print(attack_cooldown)
	pass

func _unhandled_input(event: InputEvent) -> void:
	#TODO Add case for controller related input
	if event is InputEventMouse:
		update_cursor(event)
	pass

func _physics_process(delta: float) -> void:
	##ACTIONS
	debug_text.text = str(attack_direction)
	if Input.is_action_pressed("shoot") && attack_timer.is_stopped():
		attack_timer.start()
		AudioManager.play_sfx(tommy_last)
		attack()
	if Input.is_action_just_released("shoot"):
		#AudioManager.play_sfx(tommy_last)
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
		if is_on_floor() && step_timer.is_stopped():
			step_timer.start()
			var random = randi_range(0,3)
			AudioManager.play_sfx(steps[random], -10)
			
	velocity.x = horizontalDirection * SPEED

	#velocity = velocity.normalized() * min(velocity.length(), SPEED)
	#Idle
	if velocity.x == 0 and velocity.y == 0:
		anim_player.play("Idle")
		pass
	move_and_slide()


func attack() -> void:
	var new_bullet = bullet.instantiate()
	new_bullet.global_position = cursor_spout.global_position
	var adjusted_angle = cursor.rotation_degrees + randi_range(gun_spread[0],gun_spread[1])
	new_bullet.rotation_degrees = adjusted_angle
	get_parent().add_child(new_bullet)
	pass



#TODO Split out the attack cursor as its own node?
func update_cursor(event):
	#Get mouse cursor relative to player
	#Smoothly rotate the aiming cursor towards mouse
	#Update attack_direction var
	
	#TODO create a case for controller input, right stick angle
	cursor.look_at(get_global_mouse_position())
	attack_direction = int(cursor.rotation_degrees) % 360
	
	if (attack_direction > 90 && attack_direction < 270) || (attack_direction < -90 && attack_direction > -270):
		arm.scale = Vector2(1, -1)
	else:
		arm.scale = Vector2(1, 1)
	#TODO smoothing by updating attack direction and instead moving the cursor to look at in update
	pass
