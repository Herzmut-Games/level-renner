extends Skill
class_name Walljump

export var bounce = 180
export var jump_speed = 200

func use(character: Character):
	if character.is_on_wall() and $SkillCooldown.available(): #wall jump
		character.velocity = Vector2((-1 if character.velocity.x > 0 else 1) * bounce, 0) + character.gravity_dir() * -jump_speed / 1.25
		$SkillCooldown.use()
		return true
	return false
