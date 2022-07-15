extends LevelTemplate

func _ready():
	get_tree().paused = false
	$UI/Messages/TopLeft.text = "Level 2"

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
		GlobalGame.load_level("res://levels/level02.tscn")
