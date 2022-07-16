extends Timer
class_name SkillCooldown

export var max_uses = 5;
var current_uses = 0;

func _ready():
	var _error = self.connect("timeout", self, "_timeout")

func use():
	current_uses +=1
	self.start() # reset timer

func available():
	return current_uses < max_uses
	
func _timeout():
	current_uses = max(0, current_uses-1)
