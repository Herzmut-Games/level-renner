extends LevelTemplate

func _ready():
	get_tree().paused = true
	$UI/Messages/TopLeft.text = "Level 1"
	$UI/Messages/Center.text = "Enemies ahead. I should be cautious and use my surroundings wisely..."
	yield(get_tree().create_timer(3.0), "timeout")
	$UI/Messages/Center.text = ""
	get_tree().paused = false

func _on_LevelEnd_body_entered(body):
	GlobalGame.stop_run()
	get_tree().paused = true
	
	var popup = $UI/LevelDone
	popup.level_done(level_score)
	yield(popup, "popup_hide")
	
	if popup.choice == GlobalGame.POPUP.NEXT:
		# GlobalGame.load_level("res://levels/level02.tscn")
		GlobalGame.load_level("res://scenes/Menu.tscn")
	else:
		GlobalGame.load_level("res://levels/level01.tscn")
