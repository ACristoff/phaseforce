extends Node2D

class_name Level

@export var music = preload("res://assets/music/PF_ICY_STAGE.mp3")
@export var extract_music = preload("res://assets/music/PF_EXTRACT!.mp3")

@export var quip_chance: int = 25

@onready var menu = preload("res://game/UI/menus/settings.tscn")

@onready var player_spawn: Marker2D = $SpawnPoint
@onready var hud: HUD = $HUD
@onready var extract_timer: Timer = $ExtractTimer
@onready var extract_zone: Extract_Zone = $ExtractZone

@export_category("Objectives")
@export var primary_obj: Node2D
@export var secrets: Array[Secret_Area]
@export_group("Kill X")
@export var kill_x_snowmen: bool = false
@export var kill_quantity: int = 10
@export_group("Win While X")
@export var while_full_health: bool = false
@export var while_powered_up: bool = false
@export_group("Collect X")
@export var collect_x_gifts: bool = false
@export var gift_quantity: int = 10
@export var collect_x_keycard: bool = false
@export var collect_keycard_color: String = "Red"

var optional_completed: bool = false
var secrets_found: int = 0
var character: PackedScene
var player: BasePlayer
var is_paused: bool = false
var snowmen_killed: int = 0
var keycards_collected: Array[String] = []
var gifts_collected: int = 0
var time: float = 0
var level_id = null

signal level_completed
signal game_over

func _ready():
	kill_x_snowmen = true
	process_mode = Node.PROCESS_MODE_PAUSABLE
	var spawn_char: BasePlayer = character.instantiate()
	spawn_char.global_position = player_spawn.global_position
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
	var spawners = get_tree().get_nodes_in_group("enemy_spawners")
	for spawn in spawners:
		var new_spawn: EnemySpawner = spawn
		new_spawn.enemy_spawned.connect(_on_enemy_spawned.bind() )
	var gifts = get_tree().get_nodes_in_group("gifts")
	for gift in gifts:
		var new_gift: Gift = gift
		new_gift.gift_collected.connect(_on_gift_collected.bind() )
	extract_zone.player_extracted.connect(_on_extract.bind())
	render_objectives()
	AudioManager.stop_music(false)
	play_level_music()

func play_level_music():
	AudioManager.play_music(music)

func _on_enemy_spawned(enemy_ref: EnemyBase):
	enemy_ref.enemy_death.connect(_on_player_kill.bind())

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
	time += delta

func get_time():
	return time

func _on_secret_found():
	secrets_found += 1
	hud.secret_found()


func render_objectives():
	if primary_obj is Generator:
		hud.primary_obj_label.text = "Destroy the Generator"
		primary_obj.just_destroyed.connect(_on_primary_obj_completed.bind())
	if kill_x_snowmen == true:
		hud.optional_objective_label.text = str("Kill ", snowmen_killed, " / ", kill_quantity, " Snowmen")
	if while_full_health:
		hud.optional_objective_label.text = str("Extract while at full health")
	if while_powered_up:
		hud.optional_objective_label.text = str("Extract while powered up")
	if collect_x_gifts:
		hud.optional_objective_label.text = str("Collect ", gifts_collected, " / ", gift_quantity, " gifts")
	if collect_x_keycard:
		hud.optional_objective_label.text = str("Collect the ", collect_keycard_color, " keycard")

func _on_primary_obj_completed():
	hud.complete_primary(extract_zone)
	extract_timer.start()
	AudioManager.play_music(extract_music)
	hud.timer_container.visible = true
	extract_zone.activate_extract()
	var spawners = get_tree().get_nodes_in_group("enemy_spawners")
	for spawn in spawners:
		var current_spawner: EnemySpawner = spawn
		current_spawner.extract_active = true
		if current_spawner.trigger == current_spawner.TriggerTypes.ON_EXTRACT:
			current_spawner.spawn_enemy()

func generate_level_complete_data():
	var objective = str("Objective completed: :3")
	var optional_objective = str("Optional objective completed: ", optional_completed )
	var secrets_data = str("Secrets found: ", secrets_found, " / ", secrets.size())
	var enemies = str("Enemies killed: ", snowmen_killed)
	var stars = [true, optional_completed, secrets.size() == secrets_found]
	var all = {
		"secrets": secrets_data,
		"optional_completed": optional_completed,
		"objective": objective,
		"kills": enemies,
		"stars": stars,
		"time": int(get_time()),
		"level": level_id
	}
	return all

func _on_extract():
	if player.powered_up && while_powered_up:
		optional_completed = true
	if player.health == 3 && while_full_health:
		optional_completed = true
	#print(generate_level_complete_data())
	level_completed.emit(generate_level_complete_data())

func _on_player_death():
	game_over.emit()

func _on_player_kill():
	if kill_x_snowmen && snowmen_killed != kill_quantity:
		snowmen_killed += 1
		hud.tick_up()
		hud.optional_objective_label.text = str("Kill ", snowmen_killed, " / ", kill_quantity, " Snowmen")
	if kill_x_snowmen && snowmen_killed == kill_quantity && optional_completed == false: 
		hud.optional_objective_label.text = str("Kill ", snowmen_killed, " / ", kill_quantity, " Snowmen")
		hud.complete_optional()
		optional_completed = true
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
		var new_player = body as BasePlayer
		new_player.global_position = player_spawn.global_position
		new_player.take_damage()

func _on_gift_collected():
	if collect_x_gifts && gifts_collected != gift_quantity:
		gifts_collected += 1
		hud.tick_up()
		hud.optional_objective_label.text = str("Collect ", gifts_collected, " / ", gift_quantity, " gifts")
	if collect_x_gifts && gifts_collected == gift_quantity && optional_completed == false: 
		hud.optional_objective_label.text = str("Collect ", gifts_collected, " / ", gift_quantity, " gifts")
		hud.complete_optional()
		optional_completed = true
	pass

func roll_for_quip():
	var roll = randi_range(0, 100)
	if roll < quip_chance:
		return true
	else:
		return false
