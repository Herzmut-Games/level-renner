extends Control

onready var walljump_progress = $WalljumpControl/BackgroundNinePatchRect/NinePatchRect
onready var time = $TimerControl/BackgroundNinePatchRect/Label

func _process(_delta):
	walljump_progress.visible = GlobalGame.walljump_available()
	walljump_progress.rect_size.x = GlobalGame.walljumps * 6
	time.text = GlobalGame.elapsed_time()
