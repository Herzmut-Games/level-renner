extends Control

onready var walljump_progress = $BackgroundNinePatchRect/NinePatchRect

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	walljump_progress.visible = GlobalGame.walljump_available()
	walljump_progress.rect_size.x = GlobalGame.walljumps * 6
