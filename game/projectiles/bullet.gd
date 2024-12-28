extends Area2D

@export var speed = 600

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
