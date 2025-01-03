extends Node2D
class_name Door

@onready var sound = preload("res://assets/sfx/misc/SNOW_SHOT.mp3")

@onready var light_bulb = $ElectricDoor/LightCasing/LightBulb
@onready var light = $ElectricDoor/LightCasing/LightBulb/PointLight2D
#@onready var closed_marker = $CloseMarker
#@onready var opened_marker = $OpenMarker
@onready var anim = $AnimationPlayer

@export var interactable: bool = false
@export var closed: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	#if !closed:
		#position = opened_marker.position
	AudioManager.play_sfx(sound)
	#anim.play("close")
	pass

func open():
	#print('open sesame', global_position, global_position + Vector2(0, -20))
	AudioManager.play_sfx(sound)
	anim.play("open")
	#lerp(global_position, global_position + Vector2(0, -20), 0.1)
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
	#lerp(self.position, opened_marker.position, 0.1)

#
func _physics_process(delta):
	#position.lerp(opened_marker.position + Vector2(0, -20), 0.1)
	#if closed != fal
	#position.y -= delta * 30
	#t += delta * 0.4
#
	#$Sprite2D.position = $A.position.lerp($B.position, t)
	pass
