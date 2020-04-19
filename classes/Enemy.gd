extends Entity
class_name Enemy


var soul_rect = Rect2(16,16,32,16)

export(bool)var soulbound = false

var hurt_index = 0

var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	soulbound = false
	
	SignalManager.connect("return_new_spawn_position",self,"on_new_spawn_position_returned")
	
	for i in 3:
		var sp = AudioStreamPlayer.new()
		sp.name = str("Hurt",i+1)
		sp.stream = Global.hurtsounds[i]
		add_child(sp)
	
	var sp = AudioStreamPlayer.new()
	sp.name = "Die"
	sp.stream = Global.diesounds[randi() % Global.diesounds.size()]
	add_child(sp)
	
	
	

func _physics_process(delta):
	
	check_dir()
	
	check_depth()
	

func check_dir():
	
	if position.x < 0 and dir != 1:
		dir = 1
	elif position.x > 256 and dir != -1:
		dir = -1
	
	if !flying:
		$Sprite.flip_h = true if dir < 0 else false
	else:
		$Sprite.flip_h = true if dir < 0 else false
	
func check_depth():
	
	if dead:
		return
	
	if position.y > 260:
		speed *= 0.5
		health *= 3
		$Sprite.region_rect = soul_rect
		
		if !flying:
			SignalManager.emit_signal("request_new_spawn_position",weakref(self))
		else:
			position.y = -20
		
		if soulbound:
			Global.hurt(false)
		else:
			Global.hurt(true)
		
		soulbound = true
		

func hurt(damage = 0):
	
	
	get_node(str("Hurt",hurt_index+1)).stream = Global.hurtsounds[randi() % Global.hurtsounds.size()]
	get_node(str("Hurt",hurt_index+1)).play()
	if hurt_index > 2:
		hurt_index = 0
	
	modulate = Color(10,10,10,1)
	yield(get_tree().create_timer(0.05),"timeout")
	modulate = Color(1,1,1,1)
	
	.hurt(damage)
	
	
func die():
	
	dead = true
	
	get_node("Die").stream = Global.diesounds[randi() % Global.diesounds.size()]
	get_node("Die").play()
	
	hide()
	$CollisionShape2D.disabled = true
	
	yield(get_tree().create_timer(1),"timeout")
	
	queue_free()
	
	
