extends Sprite2D

var player: BasePlayer

@export var laser_damage = 50
@onready var laser = preload("res://game/projectiles/laser.tscn")
@onready var laser_spout = $CursorSprite/Sword/Marker2D
@onready var sword = $CursorSprite/Sword

func _ready():
	player = get_tree().get_first_node_in_group("player")


func shoot_laser():
	var new_laser = laser.instantiate()
	new_laser.damage = laser_damage
	new_laser.global_position = $CursorSprite/BulletSpawnPoint.global_position
	var adjusted_angle = player.cursor.rotation_degrees
	new_laser.rotation_degrees = adjusted_angle
	get_parent().get_parent().get_parent().add_child(new_laser)

func _process(delta):
	#prints(player.global_position, laser_spout.global_position)
	pass
