extends Control

onready var walljump_progress = $LeftBottomControl/BackgroundNinePatchRect/NinePatchRect
onready var time = $LeftBottomControl/BackgroundNinePatchRect/TimeLabel
onready var healthbar = $LeftBottomControl/BackgroundNinePatchRect/HealthBar

func _process(_delta):
	walljump_progress.visible = GlobalGame.walljump_available()
	walljump_progress.rect_size.x = GlobalGame.walljumps * 6
	time.text = GlobalGame.elapsed_time()
	healthbar.rect_size.x = (GlobalGame.health * 9) - (GlobalGame.health * 1)
