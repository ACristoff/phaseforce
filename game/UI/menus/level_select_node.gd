extends Control

@onready var starone = $MarginContainer/HBoxContainer/Star1/Sprite2D
@onready var startwo = $MarginContainer/HBoxContainer/Star2/Sprite2D
@onready var starthree = $MarginContainer/HBoxContainer/Star3/Sprite2D
@onready var purplestar = preload("res://assets/ui/level_stars2.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _star_one_achieved():
	starone.texture = purplestar
func _star_two_achieved():
	startwo.texture = purplestar
func _star_three_achieved():
	starthree.texture = purplestar

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
