extends Node2D

@export var music = preload("res://assets/music/PF_MAIN_THEME.mp3")
@onready var spawn = $SpawnPoint


var character: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var spawn_char = character.instantiate()
	spawn_char.global_position = spawn.global_position
	add_child(spawn_char)


func _on_death_barrier_body_entered(body):
	print("dieded")
	if body is BasePlayer:
		print("player")
		body.global_position = spawn.global_position
