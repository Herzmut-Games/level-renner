extends Node2D

func _ready():
	$Logo.visible = false

func _on_Timer_timeout():
	if $Logo.visible:
		get_tree().change_scene("res://scenes/Menu.tscn")
	else:
		$Logo.visible = true
		$Timer.start(2)
