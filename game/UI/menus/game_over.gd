extends Node2D

signal retry
signal level_select
signal quit_to_main


func _on_button_pressed():
	retry.emit()
	pass # Replace with function body.

func _on_button_2_pressed():
	quit_to_main.emit()
	pass # Replace with function body.
