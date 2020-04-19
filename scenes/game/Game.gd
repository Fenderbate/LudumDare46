extends Node


export(NodePath)var label 

var tutorial_index = 0

var tutorial_over = false

var spawn_wait_time = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	
	Global.reset()
	
	on_soul_amount_changed()
	
	randomize()
	
	SignalManager.connect("request_new_spawn_position",self,"on_new_spawn_position_requested")
	SignalManager.connect("soul_consumed",self,"on_soul_consumed")
	SignalManager.connect("soul_amount_changed",self,"on_soul_amount_changed")
	SignalManager.connect("soulcharge_full",self,"on_soulcharge_full")
	SignalManager.connect("soulcharge_reset",self,"on_soulcharge_reset")
	SignalManager.connect("game_over",self,"on_game_over")
	SignalManager.connect("tutorial_over",self,"on_tutorial_over")
	
	for x in range(-1,17):
		for y in range(-1,17):
			$WallTileMap.set_cell(x,y,floor(rand_range(8,11)))
	
	if Global.first_time:
		tutorial(tutorial_index)
	else:
		on_tutorial_over()

func _physics_process(delta):
	
	if Global.in_soulcharge:
		$SpawnTimer.wait_time = 0.2
	else:
		$SpawnTimer.wait_time = spawn_wait_time
	

func _input(event):
	if event.is_action_pressed("R") and Global.game_over:
		get_tree().reload_current_scene()
	if event.is_action_pressed("E") and Global.first_time and tutorial_index < Global.text.size()-1:
		$UILayer/UI/Label/AnimationPlayer.play("text_hide")
	

func tutorial(index):
	if index == Global.text.size()-1:
		display_text(Global.text[Global.text.size()-1],4)
		SignalManager.emit_signal("tutorial_over")
	else:
		display_text(Global.text[index],999)
		pass

func get_new_spawn_locaiton():
	return $LeftSpawn.position if rand_range(0,100) > 50 else $RightSpawn.position

func display_text(text = "", time = 999):
	get_node(label).text = text
	$LabelTimer.wait_time = time
	$UILayer/UI/Label/AnimationPlayer.play("text_show")
	$LabelTimer.start()

func on_new_spawn_position_requested(requester):
	var pos = $LeftSpawn.position if rand_range(0,100) > 50 else $RightSpawn.position
	
	SignalManager.emit_signal("return_new_spawn_position",requester,pos)
	

func on_soul_consumed():
	$Statue/EyeProgress.value = Global.soul_charge
	

func on_soul_amount_changed():
	$UILayer/UI/MarginContainer/SoulBar.value = Global.souls

func on_soulcharge_full():
	$Statue/Eye1.emitting = true
	$Statue/Eye2.emitting = true

func on_soulcharge_reset():
	$Statue/Eye1.emitting = false
	$Statue/Eye2.emitting = false
	$Statue/EyeProgress.value = Global.soul_charge

func on_game_over(lose):
	$SpawnTimer.stop()
	$SoulTimer.stop()
	if lose:
		display_text("Useless Mortal\n [Press R to retry].",999)
	else:
		display_text("The flame burns ever higher with the souls of weak scum. \n well done, mortal.",999)

func on_tutorial_over():
	tutorial_over = true
	Global.first_time = false
	$SpawnTimer.start()
	$SoulTimer.start()

func _on_SpawnTimer_timeout():
	
	if Global.game_over:
		return
	var enemy = Global.enemies[Global.enemies.keys()[randi() % Global.enemies.keys().size()]].instance()
	if !enemy.flying:
		enemy.position = get_new_spawn_locaiton()
	else:
		enemy.position = Vector2(rand_range(20,236),-20)
	add_child(enemy)
	if $SpawnTimer.wait_time >= 0.8:
		$SpawnTimer.wait_time -= 0.03
	else:
		$SpawnTimer.wait_time = 0.8
		if !Global.in_soulcharge:
			spawn_wait_time = $SpawnTimer.wait_time
	
	$SpawnTimer.start()
	

func _on_SoulTimer_timeout():
	Global.set_soul(-1)
	if Global.souls < Global.needed_souls:
		$SoulTimer.start()


func _on_LabelTimer_timeout():
	$UILayer/UI/Label/AnimationPlayer.play("text_hide_permanent")
	


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "text_hide":
		tutorial_index += 1
		tutorial(tutorial_index)
		$UILayer/UI/Label/AnimationPlayer.play("text_show")
	if anim_name == "text_hide_permanent":
		get_node(label).text = ""
