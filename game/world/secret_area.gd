extends Area2D

class_name Secret_Area

signal secret_found

var found: bool = false

func _on_body_entered(body):
	if body is BasePlayer && !found:
		found = true
		secret_found.emit()
