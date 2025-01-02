extends Node2D

@export var music = preload("res://assets/music/PF_MAIN_THEME.mp3")
@onready var spawn = $SpawnPoint
@onready var hud = $HUD

var character: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var spawn_char: BasePlayer = character.instantiate()
	spawn_char.global_position = spawn.global_position
	add_child(spawn_char)
	spawn_char.took_damage.connect(_on_player_damage.bind())

func _on_player_damage():
	hud.take_damage()

func _on_death_barrier_body_entered(body):
	if body is BasePlayer:
		var player = body as BasePlayer
		player.global_position = spawn.global_position
		player.take_damage()
