extends Popup

onready var rating_bronze = preload("res://assets/ui/Trophy_01_01.png")
onready var rating_silver = preload("res://assets/ui/Trophy_01_02.png")
onready var rating_gold = preload("res://assets/ui/Trophy_01_03.png")

var choice = GlobalGame.POPUP.NEXT

func _ready():
	pass

func level_done(level_id : int, level_score : LevelScore):
	var time = GlobalGame.elapsed_time_raw()
	print(time)
	$Panel/VBoxContainer/Stars.texture = rating_bronze
	$Panel/VBoxContainer/Time.text = "Your time: %s" % GlobalGame.format_elapsed_time(time)
	$Panel/VBoxContainer/HighScore.text = "Highscore: %s" % GlobalGame.format_elapsed_time(level_score.high_score_time)
	
	var rating = "bronze"
	if level_score.silver_time >= time:
		$Panel/VBoxContainer/Stars.texture = rating_silver
		rating = "silver"
	if level_score.gold_time >= time:
		$Panel/VBoxContainer/Stars.texture = rating_gold
		rating = "gold"
	if level_score.high_score_time >= time:
		# TODO: Special trophy?
		$Panel/VBoxContainer/HighScore.text = "Highscore: %s" % GlobalGame.format_elapsed_time(time)
		
	GlobalGame.scores[level_id] = rating
	popup()

func _on_Next_pressed():
	choice = GlobalGame.POPUP.NEXT
	hide()

func _on_Retry_pressed():
	choice = GlobalGame.POPUP.RETRY
	hide()
