extends KinematicBody2D
class_name Entity

const GRAVITY = 300

export(bool)var flying = false
export(float)var speed = 100

export(int)var health = 1


var motion = Vector2(0,10)

var dir = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	
	if flying:
		return
	if !is_on_floor():
		motion.y = motion.y + GRAVITY * delta if !is_on_floor() else 10
	if is_on_ceiling() and motion.y < 0:
		motion.y = 0
	
	motion = move_and_slide(motion,Vector2(0,-1))
	

func hurt(damage):
	health -= damage
	if health <=0:
		die()

func die():
	print("implement death")

func spawn_soul(soul_value = 1):
	var s = Global.soul.instance()
	s.position = position
	s.soul_value = soul_value
	get_parent().add_child(s)


func on_new_spawn_position_returned(requester, new_position):
	if requester.get_ref() == self:
		position = new_position
