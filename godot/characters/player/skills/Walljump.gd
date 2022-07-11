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

func use():
	if character.is_on_wall() and $SkillCooldown.available(): #wall jump
		$AudioStreamPlayer.stream = sounds[clamp($SkillCooldown.current_uses-1, 0, sounds.size() -1)]
		$AudioStreamPlayer.play()
		character.velocity = Vector2((-1 if character.velocity.x > 0 else 1) * bounce, 0) + character.gravity_dir() * -jump_speed / 1.25
		$SkillCooldown.use()
		return true
	return false
