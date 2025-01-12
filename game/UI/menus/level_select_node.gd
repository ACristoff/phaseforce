extends Control

@onready var starone = $MarginContainer/HBoxContainer/Star1/Sprite2D
@onready var startwo = $MarginContainer/HBoxContainer/Star2/Sprite2D
@onready var starthree = $MarginContainer/HBoxContainer/Star3/Sprite2D
@onready var purplestar = preload("res://assets/ui/level_stars2.png")
@onready var level_name_label = $Level1/LevelName/Level
@onready var secrets_found = $Level1/SecretsFound/SecretsFound
@onready var best_time = $Level1/BestTime/BestTime

@export var level_name = "test"
@export var level_id: int

signal level_selected

# Called when the node enters the scene tree for the first time.
func _ready():
	level_name_label.text = level_name
	pass # Replace with function body.

func update_labels(data):
	#print(data)
	if data.stars[0]:
		_star_one_achieved()
		pass
	if data.stars[1]:
		_star_two_achieved()
		pass
	if data.stars[2]:
		_star_three_achieved()
		pass
	best_time.text = str(data.time)
	secrets_found.text = data.secrets

func _star_one_achieved():
	starone.texture = purplestar
func _star_two_achieved():
	startwo.texture = purplestar
func _star_three_achieved():
	starthree.texture = purplestar

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_play_level_button_pressed():
	level_selected.emit(level_id)
	pass # Replace with function body.


func _on_play_level_button_mouse_entered():
	print("mouse over level")
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:y", -10, .1)
	tween.tween_property(self, "position:y", 0, .1)
