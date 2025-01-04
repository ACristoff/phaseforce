extends CharacterBody2D

class_name EnemyBase

@onready var idle_timer: Timer = $Timers/IdleTimer
@onready var walk_timer: Timer = $Timers/WalkTimer
@onready var alert_timer: Timer = $Timers/AlertTimer
@onready var attack_timer: Timer = $Timers/AttackTimer
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var scan_zone: Area2D = $ScanArea
@onready var floor_cast: RayCast2D = $RayCast2D
@onready var wall_cast: RayCast2D = $WallCast
@onready var player_cast: RayCast2D = $PlayerCast
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var gun = $Gun
@onready var gun_sprite: Sprite2D = $Gun/EnemyPistol
@onready var gun_barrel: Marker2D = $Gun/Marker2D
@onready var alert_label: Label = $AlertLabel
@onready var bullet: PackedScene = preload("res://game/projectiles/enemy_bullet.tscn")
@onready var shot_sfx = preload("res://assets/sfx/projectiles/SILENCED_PISTOL.mp3")

enum ENEMY_STATES {IDLE, IDLEWALK, ALERTED}
@export var speed: int = 50
var enemy_state: ENEMY_STATES = ENEMY_STATES.IDLE
var alert: bool = false
var health: int = 100
var facing_right: bool = true
var player: BasePlayer
var senses_player: bool = false
var sees_player: bool = false
var is_searching: bool = false
var is_attacking: bool = false
var last_known_position: Vector2
@export var max_sight_distance: int = 280
@export var attack_range: int = 280 
@export var ideal_attack_range: int = 180

signal enemy_death

# Called when the node enters the scene tree for the first time.
func _ready():
	#prints(global_position, position)
	pass # Replace with function body.

func die():
	enemy_death.emit()
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
			velocity.x = 0
			walk_away_from_edge()
		if check_for_wall() && walk_timer.time_left < 1:
			velocity.x = 0
			turn(!facing_right)
		elif check_for_wall():
			velocity.x = -velocity.x
			turn(!facing_right)
	
	if enemy_state == ENEMY_STATES.ALERTED:
		var from_to = player.global_position - global_position
		if from_to.x < 0:
			from_to.x = from_to.x * -1
		if from_to.y < 0:
			from_to.y = from_to.y * -1
		if from_to.x < max_sight_distance && from_to.y < max_sight_distance:
			var player_pos = to_local(player.global_position)
			player_cast.target_position = player_pos + Vector2(0, 15)
		check_for_sight()
		#do attack here
		if senses_player || sees_player:
			last_known_position = player.global_position
			if last_known_position.x > global_position.x && !facing_right:
				turn(true)
			elif last_known_position.x < global_position.x && facing_right:
				turn(false)
			if !alert_timer.is_stopped():
				alert_timer.stop()
			if is_searching:
				is_searching = false
				velocity.x = 0
			if sees_player:
				gun_sprite.look_at(player.global_position)
				var attack_viability = check_attack_distance()
				if !attack_viability && !attack_timer.is_stopped():
					#print('attack not viable, stop timer')
					attack_timer.stop()
				elif attack_viability && attack_timer.is_stopped():
					#print('attack viable, start attack timer')
					attack_timer.start()
				#print(attack_viability, attack_timer.is_stopped())
		if !senses_player && !sees_player && alert_timer.is_stopped():
			alert_timer.start()
			if !is_searching:
				is_searching = true
				move_to_last_known()
		if !check_for_floor() && velocity.x != 0:
			velocity.x = 0
	
	#Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

func check_attack_distance():
	var distance = player.global_position - global_position
	var positiveX = int(distance.x)
	var positiveY = int(distance.y)
	if positiveX < 0:
		positiveX = positiveX * -1
	if positiveY < 0:
		positiveY = positiveY * -1
	
	if positiveX < attack_range && positiveY < attack_range:
		return "in range"
	return false

func attack():
	#print('shoot')
	AudioManager.play_sfx(shot_sfx)
	var new_enemy_bullet = bullet.instantiate()
	new_enemy_bullet.global_position = to_global(gun_barrel.position)
	var adjusted_angle = gun_sprite.rotation_degrees
	if !facing_right:
		adjusted_angle = -adjusted_angle + 180
	new_enemy_bullet.rotation_degrees = adjusted_angle
	#print(adjusted_angle)
	get_parent().add_child(new_enemy_bullet)

#func attack() -> void:
	#gun_anim.stop()
	#gun_anim.play("kickback")
	#var new_bullet = bullet.instantiate()
	#var new_shell = shell.instantiate()
	#new_bullet.damage = bullet_damage
	#new_bullet.speed = bullet_speed
	#new_bullet.global_position = cursor_spout.global_position
	#new_shell.global_position = shell_spout.global_position
	#var adjusted_angle = cursor.rotation_degrees + randi_range(gun_spread[0],gun_spread[1])
	#new_bullet.rotation_degrees = adjusted_angle
	#get_parent().add_child(new_bullet)
	#get_parent().add_child(new_shell)


func move_to_last_known():
	#print('moving to last known position at:', last_known_position)
	if last_known_position.x > global_position.x:
		#print('move right')
		velocity.x = speed
	else:
		#print("move left")
		velocity.x = -speed
	pass

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

func check_for_sight():
	if player_cast.is_colliding():
		var first = player_cast.get_collider()
		if first is BasePlayer:
			var from_to = player.global_position - global_position
			if from_to.x < 0:
				from_to.x = from_to.x * -1
			if from_to.y < 0:
				from_to.y = from_to.y * -1
			if from_to.x > max_sight_distance || from_to.y > max_sight_distance:
				sees_player = false
				return false
			sees_player = true
			return true
		else:
			sees_player = false
			return false
	else:
		sees_player = false
		return false



func go_to_alert(entity):
	enemy_state = ENEMY_STATES.ALERTED
	alert_label.visible = true
	velocity.x = 0
	if entity is BasePlayer:
		player = entity
	if entity is Bullet:
		player = get_tree().get_first_node_in_group("player")
	last_known_position = player.global_position
	idle_timer.stop()
	walk_timer.stop()
	player_cast.target_position = to_local(player.global_position)

	var from_to = player.global_position.x - self.global_position.x
	#if player to the right of enemy
	if from_to > 0:
		if !facing_right:
			turn(false)
	else:
		if facing_right:
			turn(false)

func turn(direction):
	facing_right = direction
	if direction:
		sprite.flip_h = false
		floor_cast.position.x = 10
		wall_cast.scale.x = 1
		scan_zone.scale.x = 1
		gun.scale.x = 1
		gun_barrel.position.x = 19
	else:
		sprite.flip_h = true
		floor_cast.position.x = -10
		wall_cast.scale.x = -1
		scan_zone.scale.x = -1
		gun.scale.x = -1
		gun_barrel.position.x = -17

func idle_walk_to(distance):
	anim.play("move")
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
	#print("must have been the wind...")
	alert_label.visible = false
	player_cast.target_position = Vector2(0, -50)
	is_searching = false
	enemy_state = ENEMY_STATES.IDLE
	idle()

func _on_scan_area_area_entered(area):
	if area is Bullet:
		if enemy_state == ENEMY_STATES.IDLE || enemy_state == ENEMY_STATES.IDLEWALK:
			go_to_alert(area)

func _on_scan_area_body_entered(body):
	if body is BasePlayer:
		senses_player = true
		if enemy_state == ENEMY_STATES.IDLE || enemy_state == ENEMY_STATES.IDLEWALK:
			go_to_alert(body)

func _on_scan_area_body_exited(body):
	if body is BasePlayer:
		senses_player = false


func _on_search_timer_timeout():
	pass # Replace with function body.


func _on_attack_timer_timeout():
	#print("ATTACK TIME NYAHH")
	attack_timer.stop()
	attack()
	pass # Replace with function body.
