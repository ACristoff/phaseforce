extends Control

@onready var anim = $AnimationPlayer
@onready var graphic = $CanvasLayer/ColorRect
@export var type = 1

func _ready():
	if type == 1:
		graphic.visible = true
		fade_in()
	else:
		fade_out()

func fade_out():
	anim.play("fade_out")
	
func fade_in():
	anim.play("fade_in")
	
