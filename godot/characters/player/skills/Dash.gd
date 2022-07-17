extends Skill
class_name Dash

export var dash_speed = 400

func _unhandled_input(event):
	if event.is_action_pressed("dash", false, false) and $SkillCooldown.available():
		$ImpactSound.play()
		character.state = Character.States.DASH
		var direction = character.get_movement_direction()
		if direction == 0.0:
			direction = character.velocity.x

		character.velocity.x += (1 if direction >= 0 else -1) * dash_speed
		$SkillCooldown.use()
		get_tree().set_input_as_handled()
