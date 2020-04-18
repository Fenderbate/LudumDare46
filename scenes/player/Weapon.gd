extends Area2D


var damage = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	pass
func _input(event):
	
	if event.is_action_pressed("Click") and !Global.in_soulcharge:
		if $WeaponAnimator.is_playing():
			$WeaponAnimator.stop()
		$WeaponAnimator.play("stab")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Weapon_area_entered(area):
	area.hurt(damage)
	SignalManager.emit_signal("shake_camera")


func _on_Weapon_body_entered(body):
	body.hurt(damage)
	SignalManager.emit_signal("shake_camera")
