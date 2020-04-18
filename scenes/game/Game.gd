extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	on_soul_amount_changed()
	
	randomize()
	
	SignalManager.connect("request_new_spawn_position",self,"on_new_spawn_position_requested")
	SignalManager.connect("soul_consumed",self,"on_soul_consumed")
	SignalManager.connect("soul_amount_changed",self,"on_soul_amount_changed")
	SignalManager.connect("soulcharge_full",self,"on_soulcharge_full")
	SignalManager.connect("soulcharge_reset",self,"on_soulcharge_reset")
	
	for x in range(-1,17):
		for y in range(-1,17):
			$WallTileMap.set_cell(x,y,floor(rand_range(8,11)))
	

func get_new_spawn_locaiton():
	return $LeftSpawn.position if rand_range(0,100) > 50 else $RightSpawn.position

func on_new_spawn_position_requested(requester):
	var pos = $LeftSpawn.position if rand_range(0,100) > 50 else $RightSpawn.position
	
	SignalManager.emit_signal("return_new_spawn_position",requester,pos)
	

func on_soul_consumed():
	$Statue/EyeProgress.value = Global.souls

func on_soul_amount_changed():
	$UILayer/UI/MarginContainer/SoulBar.value = Global.souls

func on_soulcharge_full():
	$Statue/Eye1.emitting = true
	$Statue/Eye2.emitting = true

func on_soulcharge_reset():
	$Statue/Eye1.emitting = false
	$Statue/Eye2.emitting = false

func _on_SpawnTimer_timeout():
	
	var enemy = Global.enemies[Global.enemies.keys()[randi() % Global.enemies.keys().size()]].instance()
	if !enemy.flying:
		enemy.position = get_new_spawn_locaiton()
	else:
		enemy.position = Vector2(rand_range(20,236),-20)
	add_child(enemy)
	

func _on_SoulTimer_timeout():
	Global.set_soul(-1)
	if Global.souls < Global.needed_souls:
		$SoulTimer.start()
