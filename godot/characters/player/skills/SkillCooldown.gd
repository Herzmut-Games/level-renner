extends Timer
class_name SkillCooldown

export var max_uses = 5;
var current_uses = 0;

func _ready():
	var _error = self.connect("timeout", self, "_timeout")

func use():
	if current_uses == max_uses:
		self.start()
	current_uses +=1

func available():
	return current_uses <= max_uses
	
func _timeout():
	current_uses = max(0, current_uses-1)
