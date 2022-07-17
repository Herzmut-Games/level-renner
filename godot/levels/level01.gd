extends LevelTemplate

func _ready():
	._ready()
	get_tree().paused = true
	$UI/Messages/TopLeft.text = "Level 1"
	$UI/Messages/Center.text = "3"
	yield(get_tree().create_timer(1.0), "timeout")
	$UI/Messages/Center.text = "2"
	yield(get_tree().create_timer(1.0), "timeout")
	$UI/Messages/Center.text = "1"
	yield(get_tree().create_timer(1.0), "timeout")
	$UI/Messages/Center.text = ""
	get_tree().paused = false

func _on_LevelEnd_body_entered(body):
	GlobalGame.stop_run()
	get_tree().paused = true

	var popup = $UI/LevelDone
	popup.level_done(1, level_score)
	yield(popup, "popup_hide")

	if popup.choice == GlobalGame.POPUP.NEXT:
		GlobalGame.load_level("res://levels/level02.tscn")
	else:
		GlobalGame.load_level("res://levels/level01.tscn")
