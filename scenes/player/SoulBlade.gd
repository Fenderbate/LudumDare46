extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SoulBlade_area_entered(area):
	area.hurt(3)
	SignalManager.emit_signal("shake_camera")


func _on_SoulBlade_body_entered(body):
	body.hurt(3)
	SignalManager.emit_signal("shake_camera")
