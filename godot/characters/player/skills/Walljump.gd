extends Skill
class_name Walljump

export var bounce = 180
export var jump_speed = 200

func _unhandled_input(event):
	if event.is_action_pressed("jump", false, false) and $SkillCooldown.available():
		var colliderLeftTop = $RayCastLeftTop.get_collider()
		var colliderLeftBottom = $RayCastLeftBottom.get_collider()
		var colliderRightTop =  $RayCastRightTop.get_collider()
		var colliderRightBottom = $RayCastRightBottom.get_collider()
		

		var collider = null
		if not(colliderLeftTop == null or colliderLeftTop.get_collision_layer() & 0b10000):
			collider = colliderLeftTop
		elif not(colliderLeftBottom == null or colliderLeftBottom.get_collision_layer() &0b10000):
			collider = colliderLeftBottom
		elif not(colliderRightTop == null or colliderRightTop.get_collision_layer() & 0b10000):
			collider = colliderRightTop  
		elif not(colliderRightBottom == null or colliderRightBottom.get_collision_layer() & 0b10000):
			collider = colliderRightBottom
		else:
			return

		get_tree().set_input_as_handled()
		
		# Pitch jump sound down by the amount of already used wall-jumps
		# add +1 since the first walljump is actually the second jump
		$AudioStreamPlayer.pitch_scale = 1/exp(float($SkillCooldown.current_uses+1)/float($SkillCooldown.max_uses))
		$AudioStreamPlayer.play()

		character.velocity = Vector2((-1 if collider == colliderRightTop or collider == colliderRightBottom else 1) * bounce, 0) + character.gravity_dir() * -jump_speed / 1.25

		$SkillCooldown.use()
