extends Control

func _input(event):
	if event is InputEventKey and event.scancode == KEY_F1:
		GlobalGame.load_level("res://Main.tscn")
	if event is InputEventKey and event.scancode == KEY_F2:
		GlobalGame.load_level("res://levels/level01.tscn")

func _on_Start_pressed():
	GlobalGame.load_level("res://levels/level00.tscn")
