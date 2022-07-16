extends Skill
class_name Attack

var last_state = null

func _ready():
	character.get_node("AnimatedSprite").connect("animation_finished", self, "finish_attack")
	character.get_node("AnimatedSpriteOverworld").connect("animation_finished", self, "finish_attack")

func use():
	if $SkillCooldown.available():
		character.state = Character.States.ATTACK
		$SkillCooldown.use()
		return true
	return false
	
func _process(delta):
	if character.state != Character.States.ATTACK:
		return
		
	if character.get_node("AnimatedSprite").visible:
		yield(character.get_node("AnimatedSprite"), "animation_finished")
	if character.get_node("AnimatedSpriteOverworld").visible:
		yield(character.get_node("AnimatedSpriteOverworld"), "animation_finished")
	
	var attack_target = get_attack_target()
	if attack_target != null and attack_target is Character:
		attack_target.hit()
	
func get_attack_target():
	var attack_bodies = $AttackArea.get_overlapping_bodies()
	if len(attack_bodies) == 0:
		return null
	return attack_bodies[0]
