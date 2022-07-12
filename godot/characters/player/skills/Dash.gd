extends Skill
class_name Dash

export var dash_speed = 5000

func _physics_process(delta):
	if Input.is_action_just_pressed("dash") and $SkillCooldown.available():
		character.state = Character.States.DASH
		var direction = character.get_movement_direction()
		if direction == 0.0:
			direction = character.velocity.x
		
		character.velocity.x += (1 if direction >= 0 else -1) * dash_speed
		$SkillCooldown.use()
