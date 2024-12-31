extends Node

class_name game_manager

@export var debug_mode = false
@onready var title = $Title

@onready var level_manager = preload("res://game/data/level_manager.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if debug_mode:
		title.queue_free()
		var start_level_man = level_manager.instantiate()
		add_child(start_level_man)
		start_level_man.load_level(0)
		pass
