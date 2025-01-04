extends Node2D
class_name Door

@onready var open_sound = preload("res://assets/sfx/misc/SNOW_SHOT.mp3")
@onready var close_sound = preload("res://assets/characters/lia/base_form/desert_eagle.png")
@onready var deny_sound = preload("res://assets/sfx/objects/GATE_DENY.mp3")

@onready var light_bulb = $ElectricDoor/LightCasing/LightBulb
@onready var light = $ElectricDoor/LightCasing/LightBulb/PointLight2D
@onready var anim = $AnimationPlayer

@export var interactable: bool = false
@export var closed: bool = true
@export var keycard: String = "None"

# Called when the node enters the scene tree for the first time.
func _ready():
	if interactable == true:
		light_bulb.modulate = Color.GREEN
		light.color = Color.GREEN
	else:
		light_bulb.modulate = Color.RED
		light.color = Color.RED

func distant_open():
	if closed:
		anim.play("open")

func check_for_keycard(_key):
	if _key == keycard && !interactable:
		light_bulb.modulate = Color.GREEN
		light.color = Color.GREEN
		interactable = true
	elif keycard != "None":
		AudioManager.play_sfx(deny_sound, -5)

func open():
	if interactable && closed:
		AudioManager.play_sfx(open_sound)
		anim.play("open")
	elif !interactable && closed:
		AudioManager.play_sfx(deny_sound, -5)

func close():
	AudioManager.play_sfx(close_sound)
	anim.play("close")
