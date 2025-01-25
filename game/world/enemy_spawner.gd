extends Node2D

class_name EnemySpawner

signal enemy_spawned

@onready var spawn_marker = $SpawnPos
@onready var trigger_area = $Area2D
@onready var frame_ticker = $FrameTicker
@onready var sprite = $Sprite2D
var sprite_counter = 0

@export var enemy_to_spawn: PackedScene 
enum TriggerTypes {ON_EXTRACT, IN_ZONE, IN_ZONE_AFTER_EXTRACT}
@export var trigger: TriggerTypes
@export var enemy_to_spawn_animation: CompressedTexture2D

var extract_active = false
var has_spawned = false

func _ready():
	sprite.texture = enemy_to_spawn_animation
	if trigger == TriggerTypes.ON_EXTRACT:
		trigger_area.visible = false

func spawn_enemy():
	has_spawned = true
	var new_enemy: EnemyBase = enemy_to_spawn.instantiate()
	get_parent().add_child(new_enemy)
	new_enemy.global_position = spawn_marker.global_position
	enemy_spawned.emit(new_enemy)
	queue_free()

func enemy_animation():
	if sprite_counter < 3:
		sprite.frame += 1
	else:
		spawn_enemy()

func _on_area_2d_body_entered(body):
	if body is BasePlayer:
		if trigger == TriggerTypes.IN_ZONE:
			if has_spawned == false:
				frame_ticker.start()
		if trigger == TriggerTypes.IN_ZONE_AFTER_EXTRACT && extract_active:
			if has_spawned == false:
				frame_ticker.start()

func _on_frame_ticker_timeout():
	enemy_animation()

func _on_sprite_2d_frame_changed():
	sprite_counter += 1
