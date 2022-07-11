extends Skill
class_name Walljump

export var bounce = 180
export var jump_speed = 200

var cooldown: SkillCooldown

func _ready():
	cooldown = SkillCooldown.new()
	add_child(cooldown)

func use(character: Character):
	print(get_children())
	
	if character.is_on_wall() and cooldown.available(): #wall jump
		character.velocity = Vector2((-1 if character.velocity.x > 0 else 1) * bounce, 0) + character.gravity_dir() * -jump_speed / 1.25
		cooldown.use()
		return true
	return false
