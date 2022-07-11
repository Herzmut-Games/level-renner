extends Skill
class_name Jump

export var jump_speed = 200

func use(character: Character):
	if character.is_on_floor():
		character.velocity += character.gravity_dir() * -jump_speed
		return true
	return false
