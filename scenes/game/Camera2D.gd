extends Camera2D


var shakes = 0

var origin = Vector2(128,128)

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.connect("shake_camera",self,"on_shake_camera")


func _physics_process(delta):
	
	if shakes > 0:
		position = origin + Vector2(rand_range(-1,1),rand_range(-1,1))
		shakes -= 1
	

func on_shake_camera():
	shakes += 5
