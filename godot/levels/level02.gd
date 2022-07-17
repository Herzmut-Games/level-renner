extends LevelTemplate

func _ready():
	get_tree().paused = false
	$UI/Messages/TopLeft.text = "Level 2"

func _on_LevelEnd_body_entered(body):
	GlobalGame.stop_run()
	get_tree().paused = true
	
	var popup = $UI/LevelDone
	popup.level_done(2, level_score)
	yield(popup, "popup_hide")
	
	if popup.choice == GlobalGame.POPUP.NEXT:
		GlobalGame.load_level("res://levels/level03.tscn")
	else:
		GlobalGame.load_level("res://levels/level02.tscn")
