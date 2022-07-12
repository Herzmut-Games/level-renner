extends Skill
class_name Jump

export var jump_speed = 50
export var max_jump_speed = 150
export var decay = 200

var jump_muliplier = 0

func _physics_process(delta):
	jump_muliplier -= decay * delta
	
	if not Input.is_action_pressed("jump") or character.state == character.States.FALL:
		return
	
	if Input.is_action_just_pressed("jump") and character.is_on_floor():
		$AudioStreamPlayer.play()
		jump_muliplier = jump_speed
		
	if jump_muliplier <= 0:
		return

	character.velocity += jump_muliplier * -character.gravity_dir()
	character.velocity.y = clamp(character.velocity.y, -max_jump_speed, max_jump_speed)
