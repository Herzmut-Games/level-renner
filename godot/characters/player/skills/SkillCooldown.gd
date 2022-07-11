extends Timer
class_name SkillCooldown

export var max_uses = 5;
var current_uses = max_uses;

func _ready():
	self.connect("timeout", self, "_timeout")

func use():
	if current_uses == max_uses:
		self.start()
	current_uses -= 1
	
func available():
	return current_uses > 0
	
func _timeout():
	if current_uses < max_uses:
		current_uses += 1
