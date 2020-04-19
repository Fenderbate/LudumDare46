extends Enemy




# Called when the node enters the scene tree for the first time.
func _ready():
	soul_rect = Rect2(32,64,32,16)
	pass
	

func _physics_process(delta):
	
	
	motion.x = dir * speed
	
	pass
	
func die():
	spawn_soul(2)
	
	.die()

