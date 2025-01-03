extends Node2D

class_name EnemySpawner

signal enemy_spawned

@onready var spawn_marker = $SpawnPos
@onready var trigger_area = $Area2D

@export var enemy_to_spawn: PackedScene 
enum TriggerTypes {ON_EXTRACT, IN_ZONE, IN_ZONE_AFTER_EXTRACT}
@export var trigger: TriggerTypes

var extract_active = false

func _ready():
	if trigger == TriggerTypes.ON_EXTRACT:
		trigger_area.visible = false

func spawn_enemy():
	print('spawning guy')
	var new_enemy: EnemyBase = enemy_to_spawn.instantiate()
	get_parent().add_child(new_enemy)
	new_enemy.global_position = spawn_marker.global_position
	prints(new_enemy.global_position, spawn_marker.global_position)


func _on_area_2d_body_entered(body):
	if body is BasePlayer:
		if trigger == TriggerTypes.IN_ZONE:
			print('spawn a dude')
			spawn_enemy()
		if trigger == TriggerTypes.IN_ZONE_AFTER_EXTRACT && extract_active:
			spawn_enemy()
