extends RigidBody2D

class_name EnemyBase

enum ENEMY_STATES {IDLE, ALERTED}
var alert: bool = false



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Add the gravity.
	#velocity += get_gravity() * delta
	pass

func idle():
	
	pass

func track_player():
	
	pass

func attack():
	
	pass
