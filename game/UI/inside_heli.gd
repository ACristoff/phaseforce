extends Node2D

var shake_amount = .2
@onready var graphic = $Insideheli
@onready var choppa = preload("res://assets/sfx/objects/CHOPPA_CLOSE.mp3")
# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.play_music(choppa)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	graphic.offset = Vector2(randi_range(-1, 1) * shake_amount, randi_range(-1, 1) * shake_amount)
