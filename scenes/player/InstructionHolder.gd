extends Node2D

var wasd = false
var mouse = false


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.connect("soulcharge_full",self,"on_soulcharge_full")
	if Global.first_time:
		$AnimationPlayer.play("wasd_show")

func _input(event):
	if event.is_action_pressed("W") or event.is_action_pressed("A") or event.is_action_pressed("S") or event.is_action_pressed("D"):
		if wasd:
			$AnimationPlayer.play("wasd_hide")
	if event.is_action_pressed("Click") and mouse:
		$AnimationPlayer.play("mouse_hide")
	if event.is_action_pressed("E") and Global.check_soulcharge():
		$AnimationPlayer.play("e_hide")

func on_soulcharge_full():
	if !$E.visible:
		$AnimationPlayer.play("e_show")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "wasd_show" and !wasd:
		wasd = true
	if anim_name == "wasd_hide" and !mouse:
		wasd = false
		$AnimationPlayer.play("mouse_show")
	if anim_name == "mouse_show" and !mouse:
		mouse = true
	if anim_name == "mouse_hide":
		mouse = false
	
