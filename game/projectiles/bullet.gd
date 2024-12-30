extends Area2D

@export var speed = 600
#@onready var PARTICLE = preload("res://assets/particles/hit_particles.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	#velocity.x = Vector2(1, 0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta
	pass


func _on_area_entered(area):
	pass # Replace with function body.
	


#
#func _on_body_entered(body):
	#if body.has_method("metal"):
		#print("hit metal tile")
		#
	#elif body.has_method("snow"):
		#var particle = PARTICLE.instantiate()
		#get_tree().current_scene.add_child(particle)
		##particle.global_position = $".".global_position
		#particle.type = 1
		#print("hit snow tile")
		#queue_free()
