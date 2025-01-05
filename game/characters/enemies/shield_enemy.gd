extends EnemyBase

class_name ShieldEnemy
#@onready var shield_parent = $Shield
@onready var shield_hitbox = $ShieldHitBox
@onready var shield_collision = $ShieldHitBox/CollisionShape2D

@export var shield_health = 120

func shield_take_damage(damage):
	shield_health -= damage
	print('shield took ', damage, 'damage')
	if shield_health < 0:
		print('shield broken')
		shield_collision.set_deferred("disabled", true)
		shield_hitbox.monitoring = false
		shield_hitbox.visible = false

func turn(direction):
	facing_right = direction
	if direction:
		sprite.flip_h = false
		floor_cast.position.x = 10
		wall_cast.scale.x = 1
		scan_zone.scale.x = 1
		gun.scale.x = 1
		gun_barrel.position.x = 19
		shield_hitbox.scale.x = 1
		sprite.scale.x = 1
	else:
		sprite.flip_h = true
		floor_cast.position.x = -10
		wall_cast.scale.x = -1
		scan_zone.scale.x = -1
		gun.scale.x = -1
		gun_barrel.position.x = -17
		shield_hitbox.scale.x = -1
		sprite.scale.x = -1
