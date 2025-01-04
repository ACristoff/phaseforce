extends Area2D

enum KEYS {RED, GREEN, BLUE}
@export var type: KEYS
@onready var sprite: Sprite2D = $Sprite2D
var key_string: String

@onready var red = preload("res://assets/particles/keycard3.png")
@onready var green = preload("res://assets/particles/keycard1.png")
@onready var blue = preload("res://assets/particles/keycard2.png")

@onready var pickup_sound = preload("res://assets/sfx/UI/ITEM_PICKUP.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	if type == KEYS.RED:
		sprite.texture = red
		key_string = "Red"
	if type == KEYS.GREEN:
		sprite.texture = green
		key_string = "Green"
	if type == KEYS.BLUE:
		sprite.texture = blue
		key_string = "Blue"


func _on_body_entered(body):
	if body is BasePlayer:
		body.add_keycard(key_string)
		AudioManager.play_sfx_wav(pickup_sound)
		queue_free()
