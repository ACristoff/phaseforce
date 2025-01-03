extends Node2D

signal enemy_spawned

@export var enemy_to_spawn: EnemyBase
#@export var  

@export var character_name: Array[String]

enum TriggerTypes {ON_EXTRACT, IN_ZONE, IN_ZONE_AFTER_EXTRACT}
@export var trigger: TriggerTypes
var extract_active = false

func spawn_enemy():
	pass




func _on_area_2d_body_entered(body):
	if body is BasePlayer:
		if trigger == TriggerTypes.IN_ZONE:
			spawn_enemy()
		if trigger == TriggerTypes.IN_ZONE_AFTER_EXTRACT && extract_active:
			spawn_enemy()
