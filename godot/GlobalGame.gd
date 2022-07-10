extends Node

var max_walljumps = 5
var walljumps = 5
var max_health = 5
var health = 5

var run_started = false
var run_start_time = 0

func _ready():
	var walljump_timer = Timer.new()
	walljump_timer.connect("timeout", self, "_on_walljump_timer_timeout")
	add_child(walljump_timer)
	walljump_timer.start(2)
	
func start_run():
	run_start_time = OS.get_system_time_msecs()
	
func elapsed_time():
	var time_now = OS.get_system_time_msecs()
	var elapsed = time_now - run_start_time
	
	var minutes = int(elapsed / 60 / 1000)
	var seconds = int(elapsed / 1000) % 60
	var miliseconds = int(elapsed) % 1000

	return "%02d:%02d:%03d" % [minutes, seconds, miliseconds]

func walljump_available():
	return walljumps > 0
	
func use_walljump():
	walljumps = walljumps - 1
	
func _on_walljump_timer_timeout():
	if walljumps < 5:
		walljumps += 1
		
func hit(amount = 1):
	if health > 1:
		health = health - amount
	else:
		# TODO: Game Over
		pass
