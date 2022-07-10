extends Control

onready var walljump_progress = $LeftBottomControl/BackgroundNinePatchRect/NinePatchRect
onready var time = $LeftBottomControl/BackgroundNinePatchRect/TimeLabel
onready var health_label = $LeftBottomControl/BackgroundNinePatchRect/HealthLabel

func _process(_delta):
	walljump_progress.visible = GlobalGame.walljump_available()
	walljump_progress.rect_size.x = GlobalGame.walljumps * 6
	time.text = GlobalGame.elapsed_time()
	health_label.text = "%d / %d" % [GlobalGame.health, GlobalGame.max_health]
