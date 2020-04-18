extends Node

var soul = preload("res://scenes/soul/Soul.tscn")

var enemies = {
	"Goblin" : preload("res://scenes/goblin/Goblin.tscn"),
	"Head" : preload("res://scenes/head/Head.tscn"),
	"Skull" : preload("res://scenes/skull/Skull.tscn")
	
	
}

const needed_souls = 100
var souls = 10

const needed_soulcharge = 33
var soul_charge = 0
var in_soulcharge = false

var lifes = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func set_soul(amount):
	souls += amount
	
	if souls >= 100:
		print("win")
		return
	elif souls <= 0:
		print("game over")
		return
	
	
	
	SignalManager.emit_signal("soul_amount_changed")
	
	if !in_soulcharge and amount > 0:
		soul_charge += 1
		
		if soul_charge >= needed_soulcharge:
			SignalManager.emit_signal("soulcharge_full")
		

func check_soulcharge():
	if soul_charge == needed_soulcharge:
		return true
	return false

func hurt(fatal = false):
	
	lifes -= 1
	
	if fatal:
		lifes = 0
	
	if lifes <= 0:
		print("game over")
	
