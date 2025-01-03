extends AnimatableBody2D

@export var interactable = true
@onready var light_bulb = $LightCasing/LightBulb
@onready var light = $LightCasing/LightBulb/PointLight2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if interactable == true:
		light_bulb.modulate = Color.GREEN
		light.color = Color.GREEN
	else:
		light_bulb.modulate = Color.RED
		light.color = Color.RED
