extends Node

var soul = preload("res://scenes/soul/Soul.tscn")


var hurtsounds = [
	preload("res://sfx/hurt1.wav"),
	preload("res://sfx/hurt2.wav"),
	preload("res://sfx/hurt3.wav")
]

var diesounds = [
	
	preload("res://sfx/die1.wav"),
	preload("res://sfx/die2.wav"),
	preload("res://sfx/die3.wav")
	
]

var game_over = false

var enemies = {
	"Goblin" : preload("res://scenes/goblin/Goblin.tscn"),
	"Head" : preload("res://scenes/head/Head.tscn"),
	"Skull" : preload("res://scenes/skull/Skull.tscn")
	
}

var text = [
	"MORTAL! \n[Press E]",
	"Defend the soulfire below!",
	"Slay the monsters who come to consume it!",
	"When killed, their soul will fall into the depths and burn!",
	"Use the fire's power when the statues eyes turn ablaze!",
	"Once a monster falls down, it will return, strengthened by the fire.",
	"If they fall once again, they will consume all of it!",
	"If the fire dies, you persish with it!",
	"DON'T. FAIL ME.'"
]

const needed_souls = 100
var souls = 10

const needed_soulcharge = 33
var soul_charge = 0
var in_soulcharge = false

var first_time = true

func reset():
	game_over = false
	souls = 10
	soul_charge = 0
	in_soulcharge = false


func set_soul(amount, exact = false):
	
	souls = souls + amount if !exact else amount
	
	
	if souls >= 100:
		game_over = true
		SignalManager.emit_signal("game_over",false)
	elif souls <= 0:
		game_over = true
		SignalManager.emit_signal("game_over",true)
	
	
	
	SignalManager.emit_signal("soul_amount_changed")
	
	if !in_soulcharge and amount > 0:
		soul_charge += 6
		
		if soul_charge >= needed_soulcharge:
			soul_charge = needed_soulcharge
			SignalManager.emit_signal("soulcharge_full")
		

func check_soulcharge():
	if soul_charge >= needed_soulcharge:
		return true
	return false

func reset_soulcharge():
	soul_charge = 0
	SignalManager.emit_signal("soulcharge_reset")

func hurt(fatal = false, damage = 1):
	
	set_soul(-damage)
	
	if fatal:
		set_soul(-10,true)
	SignalManager.emit_signal("soul_amount_changed")
	
	
