extends Node2D

@onready var collision: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var area: Area2D = $Area2D


func disable():
	collision.set_deferred("disabled", true)
	

func _on_area_2d_area_exited(area):
	collision.set_deferred("disabled", false)

func _on_area_2d_disable():
	disable()
