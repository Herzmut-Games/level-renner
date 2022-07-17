extends Control

func show():
	.show()
	$CanvasLayer/Control.show()

func hide():
	.hide()
	$CanvasLayer/Control.hide()

func _ready():
	$CanvasLayer/Control.visible = visible

func _on_MenuButton_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")

func _on_RestartButton_pressed():
	GlobalGame.health = 3
	get_tree().reload_current_scene()
