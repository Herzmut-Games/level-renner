extends Control

onready var walljump_progress = $LeftBottomControl/BackgroundNinePatchRect/NinePatchRect
onready var time = $LeftBottomControl/BackgroundNinePatchRect/TimeLabel
onready var healthbar = $LeftBottomControl/BackgroundNinePatchRect/HealthBar

func _process(_delta):
	walljump_progress.visible = GlobalGame.player.has_node("Walljump")
	walljump_progress.rect_size.x = GlobalGame.player.get_node("Walljump").cooldown.current_uses * 6
	time.text = GlobalGame.elapsed_time()
	healthbar.rect_size.x = (GlobalGame.health * 9) - (GlobalGame.health * 1)
