extends Node

class_name Level_Manager

@export var levels: Array[PackedScene] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func load_level(id):
	var new_level = levels[id].instantiate()
	add_child(new_level)
