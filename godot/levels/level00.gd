extends LevelTemplate

func _ready():
	get_tree().paused = true
	$UI/Messages/Center.text = "Finally morning. I should hurry..."
	yield(get_tree().create_timer(2.0), "timeout")
	$UI/Messages/Center.text = "You can move Left <A> and Right <D> and Jump <Space>"
	$UI/Messages/BottemLeft.text = "<- Here you can see your how your current Time and Hitpoints"
	yield(get_tree().create_timer(3.0), "timeout")
	$UI/Messages/Center.text = ""
	$UI/Messages/BottemLeft.text = ""
	GlobalGame.timer_paused_offset += 5000
	get_tree().paused = false

func _on_LevelEnd_body_entered(body):
	GlobalGame.stop_run()
	get_tree().paused = true
	
	var popup = $UI/LevelDone
	popup.level_done(level_score)
	yield(popup, "popup_hide")
	
	if popup.choice == GlobalGame.POPUP.NEXT:
		GlobalGame.load_level("res://levels/level01.tscn")
	else:
		GlobalGame.load_level("res://levels/level00.tscn")

func _on_Dash_body_entered(body):
	get_tree().paused = true
	$UI/Messages/Center.text = "You can Dash <E> over short distances"
	$UI/Messages/BottemLeft.text = "<- Dash use up Stamina indicated by grey bars"
	yield(get_tree().create_timer(3.0), "timeout")
	GlobalGame.timer_paused_offset += 3000
	$UI/Messages/Center.text = ""	
	$UI/Messages/BottemLeft.text = ""
	get_tree().paused = false
	$Dash.queue_free()

func _on_Walljump_body_entered(body):
	get_tree().paused = true
	$UI/Messages/Center.text = "You can do (multiple) Walljumps when timed correctly"
	$UI/Messages/BottemLeft.text = "<- Walljumps use up Stamina indicated by white bars"
	yield(get_tree().create_timer(3.0), "timeout")
	GlobalGame.timer_paused_offset += 3000
	$UI/Messages/Center.text = ""		
	$UI/Messages/BottemLeft.text = ""
	get_tree().paused = false
	$Walljump.queue_free()
