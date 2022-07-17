extends LevelTemplate

onready var loop = preload("res://assets/sound/gwj47_1.mp3")

func _ready():
	._ready()
	$BackgroundMusic.stream = loop
	$BackgroundMusic.play()
	$UI/Messages/TopLeft.text = "Level 1"

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
