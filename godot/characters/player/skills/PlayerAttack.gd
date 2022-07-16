extends Attack
class_name PlayerAttack

func _unhandled_input(event):
	if event.is_action_pressed("attack", false, false):
		use()
		get_tree().set_input_as_handled()
