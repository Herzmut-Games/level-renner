extends Control

export var enabled: bool = true

func show():
	.show()
	$CanvasLayer/Control.show()

func hide():
	.hide()
	$CanvasLayer/Control.hide()

func _process(_delta):
	if Input.is_action_just_pressed("escape") and enabled and GlobalGame.health > 0:
		var tree = get_tree()
		tree.paused = not tree.paused
		show() if tree.paused else hide()

func _on_ContinueButton_pressed():
	get_tree().paused = false
	hide()

func _on_MenuButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/Menu.tscn")
