extends Node2D

@onready var starone = $HBoxContainer/Star
@onready var startwo = $HBoxContainer/Star2
@onready var starthree = $HBoxContainer/Star3
@onready var purplestar = preload("res://assets/ui/largestar2.png")

func _star_one_achieved():
	starone.texture = purplestar
func _star_two_achieved():
	startwo.texture = purplestar
func _star_three_achieved():
	starthree.texture = purplestar
