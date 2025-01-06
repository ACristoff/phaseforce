extends Sprite2D

var player: BasePlayer

@export var laser_damage = 50
@onready var laser = preload("res://game/projectiles/laser.tscn")
@onready var laser_spout = $CursorSprite/Sword/Marker2D
@onready var sword = $CursorSprite/Sword

func _ready():
	player = get_tree().get_first_node_in_group("player")


func shoot_laser():
	var new_laser: Bullet = laser.instantiate()
	new_laser.damage = laser_damage
	new_laser.global_position = $CursorSprite/BulletSpawnPoint.global_position
	var adjusted_angle = player.cursor.rotation_degrees
	new_laser.rotation_degrees = adjusted_angle
	get_parent().get_parent().get_parent().add_child(new_laser)

func _process(delta):
	prints(player.global_position, laser_spout.global_position)
	

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
	#bullet_shot.emit()
	#if powered_up:
		#hud.update_bullets(str(gun_magazine, "/", gun_magazine_capacity, " x ", mags))
	#else:
		#hud.update_bullets(str(gun_magazine, "/", gun_magazine_capacity, " x ∞"))
	##print("mag", gun_magazine)
	#if gun_magazine == 0:
		#no_ammo.emit()
