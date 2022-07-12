extends Skill
class_name Walljump

export var bounce = 180
export var jump_speed = 200

onready var sounds = [
	preload("res://assets/sound/Jump_wall2.wav"),
	preload("res://assets/sound/Jump_wall3.wav"),
	preload("res://assets/sound/Jump_wall4.wav"),
	preload("res://assets/sound/Jump_wall5.wav"),
	preload("res://assets/sound/Jump_wall6.wav")
]

func _unhandled_input(event):
	if event.is_action_pressed("jump", false, false):
		var colliderLeft = $RayCastLeft.get_collider()
		var colliderRight =  $RayCastRight.get_collider()

		var collider = null
		if not(colliderLeft == null or colliderLeft.get_collision_layer() & 0x4):
			collider = colliderLeft
		elif not(colliderRight == null or colliderRight.get_collision_layer() & 0x4):
			collider = colliderRight
		else:
			return

		get_tree().set_input_as_handled()
		$AudioStreamPlayer.stream = sounds[clamp($SkillCooldown.current_uses-1, 0, sounds.size() -1)]
		$AudioStreamPlayer.play()

		character.velocity = Vector2((-1 if collider == colliderRight else 1) * bounce, 0) + character.gravity_dir() * -jump_speed / 1.25

		$SkillCooldown.use()
