extends Node

var walljumps = 5


func _ready():
	var walljump_timer = Timer.new()
	walljump_timer.connect("timeout", self, "_on_walljump_timer_timeout")
	add_child(walljump_timer)
	walljump_timer.start(2)

func walljump_available():
	return walljumps > 0
	
func use_walljump():
	walljumps = walljumps - 1
	
func _on_walljump_timer_timeout():
	if walljumps < 5:
		walljumps += 1
