extends Node2D

func _ready():
	$Logo.visible = true
	$Theme.visible = false
	$Background.visible = true

func _on_Timer_timeout():
	if $Logo.visible:
		$Logo.visible = false
		$Theme.visible = true
		$Timer.start(2)
	else:
		get_tree().change_scene("res://scenes/Logo/Logo.tscn")

