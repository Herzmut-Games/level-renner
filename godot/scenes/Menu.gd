extends Control

func _on_Start_pressed():
	GlobalGame.load_level("res://levels/level00.tscn")

func _on_LevelSelect_pressed():
	get_tree().change_scene("res://scenes/LevelSelect.tscn")


func _on_Credits_pressed():
	$CreditsDialog.popup_centered()
