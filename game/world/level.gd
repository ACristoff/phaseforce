extends Node2D

class_name Level

@export var music = preload("res://assets/music/PF_MAIN_THEME.mp3")

@export var quip_chance: int = 30

@onready var menu = preload("res://game/UI/menus/settings.tscn")

@onready var spawn: Marker2D = $SpawnPoint
@onready var hud: HUD = $HUD
@onready var extract_timer: Timer = $ExtractTimer
@onready var extract_zone: Extract_Zone = $ExtractZone

@export var primary_obj: Node2D
@export var secondary_objs: Array[Node2D]
@export var secrets: Array[Secret_Area]

var secrets_found = 0
var character: PackedScene
var player: BasePlayer
var is_paused = false

signal level_completed
signal game_over

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	var spawn_char: BasePlayer = character.instantiate()
	spawn_char.global_position = spawn.global_position
	add_child(spawn_char)
	spawn_char.took_damage.connect(_on_player_damage.bind())
	spawn_char.gained_health.connect(_on_gained_health.bind())
	spawn_char.player_death.connect(_on_player_death.bind())
	player = spawn_char
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		var new_enemy: EnemyBase = enemy
		new_enemy.enemy_death.connect(_on_player_kill.bind())
	for secret in secrets:
		secret.secret_found.connect(_on_secret_found.bind())
	extract_zone.player_extracted.connect(_on_extract.bind())
	render_objectives()
	AudioManager.stop_music(false)

func play_level_music():
	#AudioManager.play_music()
	pass

func pause_menu():
	if is_paused:
		Engine.time_scale = 1
	else:
		Engine.time_scale = 0
	is_paused = !is_paused

func _process(delta):
	if Input.is_action_just_pressed("menu"):
		pause_menu()
	if !extract_timer.is_stopped():
		hud.timer_label.text = str("TIME TO EXTRACT: ", int(extract_timer.time_left))
	pass

func _on_secret_found():
	secrets_found += 1
	hud.secret_found()

func render_objectives():
	if primary_obj is Generator:
		hud.primary_obj_label.text = "Destroy the Generator"
		primary_obj.just_destroyed.connect(_on_primary_obj_completed.bind())
	for obj in secondary_objs:
		print(obj)

func _on_primary_obj_completed():
	hud.complete_primary()
	extract_timer.start()
	hud.timer_container.visible = true
	extract_zone.activate_extract()
	#play extract music
	pass

func generate_level_complete_data():
	var objectives = str("Objectives completed: ", 2)
	var secrets = str("Secrets found: ", 0)
	var enemies = str("Enemies killed: ", 1)
	
	var all = {"secrets": secrets}
	return all

func _on_extract():
	print(generate_level_complete_data())
	level_completed.emit(generate_level_complete_data())

func _on_player_death():
	game_over.emit()

func _on_player_kill():
	if roll_for_quip():
		player.quip(player.kill_quips)

func _on_gained_health():
	hud.gain_health()
	if roll_for_quip():
		##TODO Quip here?
		player.quip(player.damaged_quips)
	
func _on_player_damage():
	hud.take_damage()
	if roll_for_quip():
		player.quip(player.damaged_quips)

func _on_death_barrier_body_entered(body):
	if body is BasePlayer:
		var player = body as BasePlayer
		player.global_position = spawn.global_position
		player.take_damage()

func roll_for_quip():
	var roll = randi_range(0, 100)
	if roll < quip_chance:
		return true
	else:
		return false
