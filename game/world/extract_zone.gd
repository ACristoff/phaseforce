extends Node2D

class_name Extract_Zone

@onready var copter = $PhaseCopter

var is_extract_active: bool = false

signal player_extracted

func _ready():
	#activate_extract()
	pass

func activate_extract():
	is_extract_active = true
	copter.visible = true

func fly_away():
	pass

func _on_area_2d_body_entered(body):
	if body is BasePlayer && is_extract_active:
		#print('extracted!')
		player_extracted.emit()
		pass
	pass # Replace with function body.
