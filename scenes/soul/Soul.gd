extends Particles2D

var soul_value = 1

var motion = Vector2(0,-50)

var target_motion = Vector2(0,150)

var turn_delta = 1



# Called when the node enters the scene tree for the first time.
func _ready():
	
	if Global.game_over:
		$Trail.visible = false
		emitting=false
	else:
		show()
	
	randomize()
	
	motion.x = 20 * rand_range(-0.8,0.8)
	motion.y += 20 * rand_range(-1,1)
	turn_delta += rand_range(-0.05,0.5)
	
	$Death.emitting = true
	

func _physics_process(delta):
	if Global.game_over:
		emitting = false
		$Trail.emitting = false
		return
	
	motion = motion.move_toward(target_motion,1)
		
	position += motion * delta
	
	
func _on_VisibilityNotifier2D_viewport_exited(viewport):
	Global.set_soul(soul_value)
	SignalManager.emit_signal("soul_consumed")
	queue_free()
