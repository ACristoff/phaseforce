extends Control

@onready var anim = $AnimationPlayer
@onready var graphic = $CanvasLayer/ColorRect
@export var do_fade_in: bool = true

func _ready():
	if do_fade_in == true:
		graphic.visible = true
		fade_in()
	else:
		fade_out()

func fade_out():
	anim.play("fade_out")
	
func fade_in():
	anim.play("fade_in")
	
