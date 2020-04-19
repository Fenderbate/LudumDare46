extends Enemy


var deltasum = deg2rad(90)

var descend_speed = 30

var shuffle_speed = speed


# Called when the node enters the scene tree for the first time.
func _ready():
	soul_rect = Rect2(32,96,16,16)
	motion.y = rand_range(descend_speed,descend_speed * 1.2)


func _physics_process(delta):
	
	dir = sin(deltasum)
	
	
	deltasum += delta * 4
	
	motion.x = dir * shuffle_speed
	
	motion = move_and_slide(motion)

func die():
	spawn_soul(1)
	
	.die()
