extends Enemy


var jump_started = false

var jump_speed = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	soul_rect = Rect2(32,80,32,16)


func _physics_process(delta):
	
	if is_on_floor():
		if !jump_started:
			motion.y = 20
			motion.x = 0
			$JumpTimer.start()
			jump_started = true
	elif !is_on_floor():
		motion.x = dir * jump_speed
		if  jump_started:
			jump_started = false
	
func jump():
	jump_speed = rand_range(speed/2,speed)
	motion.y = -100
	

func _on_JumpTimer_timeout():
	jump()

func die():
	spawn_soul(3)
	queue_free()
