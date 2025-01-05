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
@onready var platform_area: Area2D = $PlatformDetector
@onready var door_detector: Area2D = $DoorDetector

@onready var attack_timer: Timer = $Timers/AttackTimer
@onready var reload_timer: Timer = $Timers/ReloadTimer
@onready var step_timer: Timer = $Timers/StepTimer
@onready var invul_timer: Timer = $Timers/InvulTimer
@onready var jump_buffer_timer: Timer = $Timers/JumpBufferTimer
@onready var empty_click_timer: Timer = $Timers/EmptyClickTimer

@onready var steps = [
	preload("res://assets/sfx/misc/SNOW_STEP_1.mp3"), 
	preload("res://assets/sfx/misc/SNOW_STEP_2.mp3"), 
	preload("res://assets/sfx/misc/SNOW_STEP_3.mp3"),
	preload("res://assets/sfx/misc/SNOW_STEP_4.mp3")
]
@onready var player_hurt_sfx: AudioStreamMP3 = preload("res://assets/sfx/misc/PF_PLAYER_HURT.mp3")
@onready var gain_heart_sound: AudioStreamWAV = preload("res://assets/sfx/projectiles/Magic_Healing_Minor.wav")
@onready var reload_sound: AudioStreamMP3 = preload("res://assets/sfx/projectiles/RELOAD.mp3")
@onready var empty_mag_sound: AudioStreamMP3 = preload("res://assets/sfx/UI/AMMO_DEPLETED.mp3")
@onready var power_up_sound: AudioStreamWAV = preload("res://assets/sfx/characters/PF_POWERUP.wav") 

##TODO Destructurize this
@onready var bullet = preload("res://game/projectiles/bullet.tscn")
@onready var shell = preload("res://game/projectiles/spent_shell.tscn")

@export_group("Quips")
#@export var heal_quips: Array[AudioStreamMP3 || A]
@export var death_quips: Array[AudioStreamMP3] = [preload("res://assets/music/Pippa the Ripper.mp3")]
@export var damaged_quips: Array[AudioStreamMP3] = [preload("res://assets/music/Pippa the Ripper.mp3")]
@export var kill_quips: Array[AudioStreamMP3] = [preload("res://assets/music/Pippa the Ripper.mp3")]
@export var power_up_quips: Array[AudioStreamMP3] = [preload("res://assets/music/Pippa the Ripper.mp3")]
@export var victory_quips: Array[AudioStreamMP3] = [preload("res://assets/music/Pippa the Ripper.mp3")]
@export var jump_sound: AudioStreamMP3 = preload("res://assets/sfx/characters/JUMP.mp3")

@export_group("Base Stats")
@export var JUMP_VELOCITY = -280.0
@export var SPEED: float = 150
@export var coyote_time: float = 0.25
@onready var coyote_timer: float = coyote_time
@onready var gun_sound: AudioStreamMP3 = preload("res://assets/sfx/projectiles/TOMMY_GUN_ONESHOT_LAST.mp3")


@export_category("Guns")
@export_group("Normal Mode")
@export var normal_sprite: Texture2D 
@export var normal_gun: PackedScene
@export var normal_fire_rate: float
@export var normal_gun_spread: Array[int] = [0,0]
@export var normal_bullet_speed: int
@export var normal_damage: int
@export var normal_gun_sound: AudioStreamMP3
@export var normal_gun_capacity: int = 5
@export var normal_gun_reload_time: float = 1.2
@export var normal_bullet_hud_sprite: CompressedTexture2D = preload("res://assets/ui/ammo_types/223remington.png")

@export_group("Powered Up Mode")
@export var powered_up_gun: PackedScene
@export var powered_up_sprite: Texture2D
@export var powered_up_fire_rate: float
@export var powered_up_gun_spread: Array[int] = [-1, 2]
@export var powered_up_bullet_speed: int =  500
@export var powered_up_damage: int
@export var powered_up_gun_sound: AudioStreamMP3
@export var powered_up_gun_capacity: int = 60
@export var powered_up_gun_mags: int = 2
@export var powered_up_gun_reload_time: float = 2
@export var powered_up_bullet_hud_sprite: CompressedTexture2D = preload("res://assets/ui/ammo_types/45cal.png")

var gun_spread = normal_gun_spread
var fire_rate: float = normal_fire_rate
var mags
var gun_magazine_capacity
var gun_magazine
var bullet_speed
var bullet_damage
var reload_time

var keycards = []
var health: int = 3
var powered_up: bool = false
var knockback = Vector2.ZERO
var face_right: bool = true
var attack_direction
var current_platform_stack: Array = []
var current_door: Door
var is_active: bool = false
var hud: HUD

signal took_damage
signal gained_health
signal player_death
signal bullet_shot
signal reloaded
signal no_ammo
signal powered_up_signal

func quip(quip_array):
	var random_quip = randi_range(0, quip_array.size() - 1)
	var quip = quip_array[random_quip]
	AudioManager.play_quip(quip)

func _ready() -> void:
	fire_rate = normal_fire_rate
	hud = get_tree().get_first_node_in_group("hud")
	var game_man: game_manager = get_node("/root/GameManager")
	if game_man.debug_mode:
		debug_text.visible = true
	sprite.texture = normal_sprite
	load_gun(normal_gun, false)
	attack_timer.wait_time = fire_rate
	gun_sound = normal_gun_sound
	bullet_speed = normal_bullet_speed
	bullet_damage = normal_damage
	reload_time = normal_gun_reload_time
	reload_timer.wait_time = reload_time
	gun_magazine = normal_gun_capacity
	gun_magazine_capacity = normal_gun_capacity
	hud.new_bullet_sprite = normal_bullet_hud_sprite
	hud.change_bullet_sprite()
	hud.update_bullets(str(gun_magazine, "/", gun_magazine_capacity, " x ∞"))
	

func add_keycard(_key):
	keycards.append(_key)

func gain_heart():
	gained_health.emit()
	AudioManager.play_sfx_wav(gain_heart_sound)
	if health < 3:
		health += 1

func start_reload():
	if reload_timer.is_stopped():
		##TODO ANIMATION
		gun_anim.play("reload")
		reload_timer.start()
		reloaded.emit()

func reload():
	gun_magazine = gun_magazine_capacity
	AudioManager.play_sfx(reload_sound)
	if powered_up:
		mags -= 1
		hud.update_bullets(str(gun_magazine, "/", gun_magazine_capacity, " x ", mags))
	else:
		hud.update_bullets(str(gun_magazine, "/", gun_magazine_capacity, " x ∞"))

func take_damage():
	if invul_timer.is_stopped():
		invul_timer.start()
		took_damage.emit()
		AudioManager.play_sfx(player_hurt_sfx)
		health -= 1
	else:
		pass


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

func power_up():
	if health < 3:
		if health == 2:
			gained_health.emit()
		if health == 1:
			gained_health.emit()
			gained_health.emit()
		health = 3
	sprite.texture = powered_up_sprite
	load_gun(powered_up_gun, true)
	fire_rate = powered_up_fire_rate
	attack_timer.wait_time = fire_rate
	gun_sound = powered_up_gun_sound
	bullet_speed = powered_up_bullet_speed
	bullet_damage = powered_up_damage
	gun_spread = powered_up_gun_spread
	gun_magazine = powered_up_gun_capacity
	gun_magazine_capacity = powered_up_gun_capacity
	##TODO ALLOW FOR MULTIPLE PICKUPS
	mags = powered_up_gun_mags
	powered_up = true
	reload_timer.wait_time = powered_up_gun_reload_time
	hud.new_bullet_sprite = powered_up_bullet_hud_sprite
	hud.change_bullet_sprite()
	hud.update_bullets(str(gun_magazine, "/", gun_magazine_capacity, " x ", mags))
	AudioManager.play_sfx_wav(power_up_sound)
	quip(power_up_quips)


func power_down():
	sprite.texture = normal_sprite
	load_gun(normal_gun, true)
	fire_rate = normal_fire_rate
	attack_timer.wait_time = fire_rate
	gun_sound = normal_gun_sound
	bullet_speed = normal_bullet_speed
	bullet_damage = normal_damage
	gun_spread = normal_gun_spread
	gun_magazine = normal_gun_capacity
	reload_timer.wait_time = normal_gun_reload_time
	gun_magazine_capacity = normal_gun_capacity
	hud.new_bullet_sprite = normal_bullet_hud_sprite
	hud.change_bullet_sprite()
	hud.update_bullets(str(gun_magazine, "/", gun_magazine_capacity, " x ∞"))
	powered_up = false

func jump(force):
	AudioManager.play_sfx(jump_sound, 10)
	coyote_timer = 0
	velocity.y = force

func _physics_process(delta: float) -> void:
	if health == 0:
		player_death.emit()
		health = -1
	
	##ACTIONS
	debug_text.text = str(attack_direction)
	if Input.is_action_pressed("shoot") && attack_timer.is_stopped():
		if reload_timer.is_stopped() && gun_magazine > 0:
			attack_timer.start()
			AudioManager.play_sfx(gun_sound)
			attack()
	if Input.is_action_just_pressed("shoot") && gun_magazine <= 0:
		AudioManager.play_sfx(empty_mag_sound)
	if Input.is_action_just_pressed("interact") && current_door:
		if current_door.closed:
			current_door.open()
	if Input.is_action_just_pressed("reload"):
		if powered_up:
			if mags > 0:
				start_reload()
		else:
			start_reload()
	##PLAYER MOVEMENT##
	#Add the gravity.
	if not is_on_floor() && !is_ladder():
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
		door_detector.scale.x = horizontalDirection
		##Footsteps
		if is_on_floor() && step_timer.is_stopped():
			step_timer.start()
			var random = randi_range(0,3)
			AudioManager.play_sfx(steps[random], -10)
	
	velocity.x = horizontalDirection * SPEED + knockback.x
	
	if knockback.x != 0:
		knockback = lerp(knockback, Vector2.ZERO, 0.1)
	
	if knockback.x < 1 && knockback.x > -1:
		knockback = Vector2.ZERO
	
	if floor_cast.is_colliding():
		if is_ladder():
			if Input.is_action_pressed("move_up") or Input.is_action_pressed("jump"):
				velocity.y = -SPEED
			elif Input.is_action_pressed("move_down"):
				velocity.y = SPEED
				pass
			else:
				velocity.y = 0
	
	if current_platform_stack.size() > 0:
		if Input.is_action_pressed("move_down"):
			for platform in current_platform_stack:	
				platform.disable_platform()
		elif Input.is_action_just_released("move_down"):
			for platform in current_platform_stack:
				platform.enable_platform()
	if powered_up && gun_magazine == 0 && mags <= 0:
		power_down()
	#Idle
	if velocity == Vector2(0,0) or velocity == Vector2.ZERO:
		anim_player.play("Idle")
	move_and_slide()

func is_passthrough_platform():
	var first_collide = floor_cast.get_collider()
	if first_collide is passthrough_platform:
		return first_collide
	else:
		return false

func is_ladder():
	if floor_cast.is_colliding():
		var first_collide = floor_cast.get_collider()
		if first_collide is ladder:
			return true
		else:
			return false
	else: 
		return false

func attack() -> void:
	gun_anim.stop()
	gun_anim.play("kickback")
	var new_bullet = bullet.instantiate()
	var new_shell = shell.instantiate()
	new_bullet.damage = bullet_damage
	new_bullet.speed = bullet_speed
	new_bullet.global_position = cursor_spout.global_position
	new_shell.global_position = shell_spout.global_position
	var adjusted_angle = cursor.rotation_degrees + randi_range(gun_spread[0],gun_spread[1])
	new_bullet.rotation_degrees = adjusted_angle
	get_parent().add_child(new_bullet)
	get_parent().add_child(new_shell)
	bullet_shot.emit()
	gun_magazine -= 1
	if powered_up:
		hud.update_bullets(str(gun_magazine, "/", gun_magazine_capacity, " x ", mags))
	else:
		hud.update_bullets(str(gun_magazine, "/", gun_magazine_capacity, " x ∞"))
	#print("mag", gun_magazine)
	if gun_magazine == 0:
		no_ammo.emit()


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


func _on_platform_detector_area_entered(area):
	current_platform_stack.append(area)

func _on_platform_detector_area_exited(area):
	area.enable_platform()
	current_platform_stack.erase(area)

func _on_door_detector_body_entered(body):
	current_door = body.get_parent()
	if keycards.size() > 0:
		for keycard in keycards:
			current_door.check_for_keycard(keycard)

func _on_door_detector_body_exited(_body):
	current_door = null

func _on_reload_timer_timeout():
	reload()
