extends Skill
class_name Jump

export var jump_speed = 50
export var max_jump_speed = 150
export var decay = 200

var jump_muliplier = 0

func _unhandled_input(event):
	if event.is_action_pressed("jump", false, false) and( $RayCastLeft.is_colliding() or $RayCastRight.is_colliding()):
		$AudioStreamPlayer.play()
		jump_muliplier = jump_speed

		character.velocity.y = jump_speed * -character.gravity_dir().y
		character.velocity.y = clamp(character.velocity.y, -max_jump_speed, max_jump_speed)
		get_tree().set_input_as_handled()

func _physics_process(delta):
	jump_muliplier -= decay * delta
	$RayCastLeft.cast_to.y = abs($RayCastLeft.cast_to.y) * character.gravity_dir().y
	$RayCastLeft.position.y = -abs($RayCastLeft.position.y) * character.gravity_dir().y

	$RayCastRight.cast_to.y = abs($RayCastRight.cast_to.y) * character.gravity_dir().y
	$RayCastRight.position.y = -abs($RayCastRight.position.y) * character.gravity_dir().y

	if Input.is_action_pressed("jump") and jump_muliplier >= 0 and character.state != character.States.FALL:
		character.velocity.y += jump_muliplier * -character.gravity_dir().y
		character.velocity.y = clamp(character.velocity.y, -max_jump_speed, max_jump_speed)
