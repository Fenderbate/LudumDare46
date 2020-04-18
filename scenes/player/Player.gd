extends Entity


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _input(event):
	
	if (event.is_action_pressed("Space") or event.is_action_pressed("W")):
		if $FloorCheck.is_colliding():
			jump()
		else:
			$JumpTimer.start()
	if event.is_action_pressed("E") and Global.check_soulcharge() and !Global.in_soulcharge:
		toggle_soulblade()
	
	

func _physics_process(delta):
	
	if Global.in_soulcharge and Input.is_action_pressed("Click"):
		if !$Hand/SoulBlade/SoulBladeAP.is_playing():
			$Hand/SoulBlade/SoulBladeAP.play("Spin")
	
	check_bounds()
	
	cyote_jump()
	
	$Hand.look_at(get_global_mouse_position())
	if abs($Hand.rotation_degrees) >= 360:
		$Hand.rotation_degrees = 0
	
	if abs($Hand.rotation_degrees) >= 90 and abs($Hand.rotation_degrees) <= 270:
		$Sprite.flip_h = true
		$Hand/Weapon/SpriteHolder.scale.y = -1
	else:
		$Hand/Weapon/SpriteHolder.scale.y = 1
		$Sprite.flip_h = false
	
	dir = int(Input.is_action_pressed("D")) - int(Input.is_action_pressed("A"))
	
	
	motion.x = dir * speed
	

func cyote_jump():
	
	if $JumpTimer.time_left > 0 and $FloorCheck.is_colliding():
		jump()
	

func jump():
	motion.y = -200

func check_bounds():
	if position.x < -10:
		position.x = 260
	elif position.x > 260:
		position.x = -10
	if position.y > 260:
		position.y = -10

func toggle_soulblade():
	
	Global.in_soulcharge = !Global.in_soulcharge
	$Hand/SoulBlade.visible = !$Hand/SoulBlade.visible
	$Hand/Weapon.visible = !$Hand/Weapon.visible
	$Hand/SoulBlade/SoulBladeShape.disabled = !$Hand/SoulBlade/SoulBladeShape.disabled
	if $SoulChargeTimer.time_left == 0:
		$SoulChargeTimer.start()
	




func _on_SoulChargeTimer_timeout():
	toggle_soulblade()
