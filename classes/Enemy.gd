extends Entity
class_name Enemy


var soul_rect = Rect2(16,16,32,16)

var soulbound = false


# Called when the node enters the scene tree for the first time.
func _ready():
	
	SignalManager.connect("return_new_spawn_position",self,"on_new_spawn_position_returned")

func _physics_process(delta):
	
	check_dir()
	
	check_depth()
	

func check_dir():
	
	if position.x < 0 and dir != 1:
		dir = 1
	elif position.x > 256 and dir != -1:
		dir = -1
	
	if !flying:
		$Sprite.scale.x = dir if dir != 0 else 1
	else:
		$Sprite.scale.x = floor(dir) if dir < 0 else ceil(dir)
	
func check_depth():
	if position.y > 260:
		speed *= 0.5
		health *= 3
		$Sprite.region_rect = soul_rect
		
		if !flying:
			SignalManager.emit_signal("request_new_spawn_position",weakref(self))
		else:
			position.y = -20
		
		Global.hurt(soulbound)
		
		soulbound = true
		

func hurt(damage = 0):
	
	modulate = Color(10,10,10,1)
	yield(get_tree().create_timer(0.05),"timeout")
	modulate = Color(1,1,1,1)
	
	.hurt(damage)
	
	
