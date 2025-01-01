extends GPUParticles2D
@export var type = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	emitting = true
	if type == 1:
		self.modulate = Color.WHITE
	else: 
		self.modulate = Color.YELLOW


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
