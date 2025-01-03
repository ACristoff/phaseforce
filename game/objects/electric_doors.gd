extends AnimatableBody2D

@onready var sound = preload("res://assets/sfx/misc/SNOW_SHOT.mp3")

@onready var light_bulb = $LightCasing/LightBulb
@onready var light = $LightCasing/LightBulb/PointLight2D
@onready var closed_marker = $CloseMarker
@onready var opened_marker = $OpenMarker

@export var interactable: bool = false
@export var closed: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if !closed:
		position = opened_marker.position

func open():
	print('open sesame')
	AudioManager.play_sfx(sound)
	pass

func close():
	print('close!')
	AudioManager.play_sfx(sound)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if interactable == true:
		light_bulb.modulate = Color.GREEN
		light.color = Color.GREEN
	else:
		light_bulb.modulate = Color.RED
		light.color = Color.RED
