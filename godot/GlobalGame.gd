extends Node

export var max_walljumps = 5
export var walljumps = 5
export var max_dashes = 3
export var dashes = 3
export var max_health = 3
export var health = 3

var run_started = false
var run_start_time = 0
var run_stop_time = false
var timer_paused_offset = 0

var camera : Camera2D
var player : Player

enum POPUP{ NEXT, RETRY }

var scores = {}

func _ready():
	pass
	
func init(c, p):
	camera = c
	player = p
	start_run()
	
func load_level(level, h = 3, wj = 5):
	var _error = get_tree().change_scene(level)
	health = h
	walljumps = wj
	
func start_run():
	run_start_time = OS.get_system_time_msecs()
	
func stop_run():
	run_stop_time = OS.get_system_time_msecs()
	
func elapsed_time_raw():
	var time_now = run_stop_time if (run_stop_time) else OS.get_system_time_msecs()
	return time_now - run_start_time - timer_paused_offset	

func elapsed_time():
	return format_elapsed_time(elapsed_time_raw())
	
func format_elapsed_time(elapsed):
	var minutes = int(elapsed / 60 / 1000)
	var seconds = int(elapsed / 1000) % 60
	var miliseconds = int(elapsed) % 1000

	return "%02d:%02d:%03d" % [minutes, seconds, miliseconds]		
		
func hit(amount = 1):
	camera.shake(0.2,25,6)
	health = health - amount
	if health <= 0:
		health = 0
		
		var _error = get_tree().change_scene("res://scenes/GameOver.tscn")
		# TODO: Game Over
		pass
