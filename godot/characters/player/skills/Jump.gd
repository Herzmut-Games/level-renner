extends Skill
class_name Jump

export var jump_speed = 50
export var max_jump_speed = 150
export var decay = 200

var jump_muliplier = 0

func use():
	if character.state == Character.States.FALL or jump_muliplier <= 0:
		return false
	
	if jump_muliplier == jump_speed:
		$AudioStreamPlayer.play()

	character.velocity += jump_muliplier * -character.gravity_dir()
	character.velocity.y = clamp(character.velocity.y, -max_jump_speed, max_jump_speed)
	return true

func _process(delta):
	if character.is_on_floor():
		jump_muliplier = jump_speed
	elif jump_muliplier >= 0:
		jump_muliplier -= decay * delta
