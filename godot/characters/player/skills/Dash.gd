extends Skill
class_name Dash

export var dash_speed = 5000

func use():
	if $SkillCooldown.available():
		var direction = character.get_movement_direction()
		if direction == 0.0:
			direction = character.velocity.x
		
		character.velocity.x += (1 if direction >= 0 else -1) * dash_speed
		$SkillCooldown.use()
		
		return true
	return false
