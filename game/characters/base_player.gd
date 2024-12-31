extends CharacterBody2D
class_name BasePlayer

@onready var sprite: Sprite2D = $Sprite2D
@onready var camera: Camera2D = $Camera2D

##Gun Specific stuff loaded and assigned on ready
@onready var cursor = $AttackCursor
@onready var cursor_sprite
@onready var arm
@onready var cursor_spout: Marker2D
@onready var shell_spout: Marker2D
@onready var blast_graphic: Sprite2D
@onready var gun_anim: AnimationPlayer

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var debug_text: Label = $Label
@onready var floor_cast: RayCast2D = $RayCast2D

@onready var attack_timer: Timer = $Timers/AttackTimer
#@onready var cooldown_timer: Timer = $Timers/CooldownTimer
@onready var step_timer: Timer = $Timers/StepTimer
@onready var invul_timer: Timer = $Timers/InvulTimer
@onready var jump_buffer_timer: Timer = $Timers/JumpBufferTimer

@onready var steps = [
	preload("res://assets/sfx/misc/SNOW_STEP_1.mp3"), 
	preload("res://assets/sfx/misc/SNOW_STEP_2.mp3"), 
	preload("res://assets/sfx/misc/SNOW_STEP_3.mp3"),
	preload("res://assets/sfx/misc/SNOW_STEP_4.mp3")
]

@export_group("Normal Mode")
@export var normal_sprite: Texture2D 
@export var normal_gun: PackedScene
@export var normal_fire_rate: float = 1
@export var normal_gun_spread: Array[int] = [0,0]
@export var normal_bullet_speed: int
@export var normal_damage: int
@export var normal_gun_sound: AudioStreamMP3

@export_group("Powered Up Mode")
@export var powered_up_gun: PackedScene
@export var powered_up_sprite: Texture2D
@export var powered_up_fire_rate: float = 1
@export var powered_up_gun_spread: Array[int] = [-1, 2]
@export var powered_up_bullet_speed: int =  500
@export var powered_up_damage: int
@export var powered_up_gun_sound: AudioStreamMP3

##TODO Destructurize this
@onready var bullet = preload("res://game/projectiles/bullet.tscn")
@onready var shell = preload("res://game/projectiles/spent_shell.tscn")


@export_group("Base Stats")
@export var JUMP_VELOCITY = -280.0
@export var SPEED: float = 150
@export var coyote_time: float = 0.25
@onready var coyote_timer: float = coyote_time
@onready var gun_sound: AudioStreamMP3 = preload("res://assets/sfx/projectiles/TOMMY_GUN_ONESHOT_LAST.mp3")
var gun_spread = normal_gun_spread
var fire_rate = normal_fire_rate
var bullet_speed

var health: int = 3

var powered_up: bool = false
var knockback = Vector2.ZERO
var face_right: bool = true
var attack_direction

func _ready() -> void:
	var game_man: game_manager = get_node("/root/GameManager")
	if game_man.debug_mode:
		debug_text.visible = true
	sprite.texture = normal_sprite
	load_gun(normal_gun, false)
	attack_timer.wait_time = fire_rate
	gun_sound = normal_gun_sound
	bullet_speed = normal_bullet_speed

func load_gun(gun, is_new):
	if is_new:
		cursor.remove_child(arm)
		arm.queue_free()
	var new_gun = gun.instantiate()
	cursor.add_child(new_gun)
	arm = $AttackCursor/Arm
	cursor_sprite = $AttackCursor/Arm/CursorSprite
	cursor_spout = $AttackCursor/Arm/CursorSprite/BulletSpawnPoint
	shell_spout = $AttackCursor/Arm/CursorSprite/ShellSpawnPoint
	blast_graphic = $AttackCursor/Arm/CursorSprite/GunExplosion
	blast_graphic.visible = false
	gun_anim = $AttackCursor/Arm/CursorSprite/AnimationPlayer

func _unhandled_input(event: InputEvent) -> void:
	#TODO Add case for controller related input
	if event is InputEventMouse:
		update_cursor(event)
	pass

func power_up():
	sprite.texture = powered_up_sprite
	load_gun(powered_up_gun, true)
	fire_rate = powered_up_fire_rate
	attack_timer.wait_time = fire_rate
	gun_sound = powered_up_gun_sound
	bullet_speed = powered_up_bullet_speed
	powered_up = true


func power_down():
	sprite.texture = normal_sprite
	load_gun(normal_gun, true)
	fire_rate = normal_fire_rate
	attack_timer.wait_time = fire_rate
	gun_sound = normal_gun_sound
	bullet_speed = normal_bullet_speed
	powered_up = false


func jump(force):
	#AudioManager.play_sfx()
	coyote_timer = 0
	velocity.y = force

func _physics_process(delta: float) -> void:
	##ACTIONS
	debug_text.text = str(attack_direction)
	if Input.is_action_pressed("shoot") && attack_timer.is_stopped():
		attack_timer.start()
		AudioManager.play_sfx(gun_sound)
		attack()
	if Input.is_action_just_released("shoot"):
		#AudioManager.play_sfx(tommy_last)
		pass
	
	##PLAYER MOVEMENT##
	#Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		coyote_timer -= 1 * delta
	
	#Jump Buffering
	if Input.is_action_just_pressed("jump") && !is_on_floor() && jump_buffer_timer.is_stopped():
		jump_buffer_timer.start()
	if !jump_buffer_timer.is_stopped() && is_on_floor():
		jump(JUMP_VELOCITY)
	
	#Coyote Time and Jumping
	if Input.is_action_just_pressed("jump") && coyote_timer > 0:
		jump(JUMP_VELOCITY)
	if is_on_floor() && !Input.is_action_just_pressed("jump") && coyote_timer != coyote_time:
		if jump_buffer_timer.is_stopped():
			coyote_timer = coyote_time
	var horizontalDirection = Input.get_axis("move_left", "move_right")
	
	#Flip the sprite whether moving left or right
	if horizontalDirection:
		anim_player.play("Run")
		sprite.flip_h = (horizontalDirection == -1)
		face_right = (horizontalDirection == 1)
		##Footsteps
		if is_on_floor() && step_timer.is_stopped():
			step_timer.start()
			var random = randi_range(0,3)
			AudioManager.play_sfx(steps[random], -10)
	
	velocity.x = horizontalDirection * SPEED + knockback.x
	
	if knockback.x != 0:
		knockback = lerp(knockback, Vector2.ZERO, 0.1)
		pass
	#Idle
	if velocity.x == 0 and velocity.y == 0:
		anim_player.play("Idle")
		pass
	move_and_slide()

func attack() -> void:
	#tommy_anim.stop()
	gun_anim.stop()
	gun_anim.play("kickback")
	#tommy_anim.play("TommyKick")
	var new_bullet = bullet.instantiate()
	var new_shell = shell.instantiate()
	new_bullet.speed = bullet_speed
	new_bullet.global_position = cursor_spout.global_position
	new_shell.global_position = shell_spout.global_position
	var adjusted_angle = cursor.rotation_degrees + randi_range(gun_spread[0],gun_spread[1])
	new_bullet.rotation_degrees = adjusted_angle
	
	get_parent().add_child(new_bullet)
	get_parent().add_child(new_shell)




#TODO Split out the attack cursor as its own node?
func update_cursor(_event):
	#Get mouse cursor relative to player
	#Smoothly rotate the aiming cursor towards mouse
	#Update attack_direction var
	
	#TODO create a case for controller input, right stick angle
	cursor.look_at(get_global_mouse_position())
	attack_direction = int(cursor.rotation_degrees) % 360
	if arm:
		if (attack_direction > 90 && attack_direction < 270) || (attack_direction < -90 && attack_direction > -270):
			arm.scale = Vector2(1, -1)
		else:
			arm.scale = Vector2(1, 1)
	#TODO smoothing by updating attack direction and instead moving the cursor to look at in update
	pass
