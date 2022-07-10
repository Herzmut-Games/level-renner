extends Node

export var max_walljumps = 5
export var walljumps = 5
export var max_health = 3
export var health = 3

var run_started = false
var run_start_time = 0

var camera : Camera2D
var player : KinematicBody2D

func _ready():
	var walljump_timer = Timer.new()
	walljump_timer.connect("timeout", self, "_on_walljump_timer_timeout")
	add_child(walljump_timer)
	walljump_timer.start(2)
	
func init(c, p):
	camera = c
	player = p
	start_run()
	
func load_level(level, h = 3, wj = 5):
	get_tree().change_scene(level)
	health = h
	walljumps = wj
	
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
	camera.shake(0.2,25,6)
	health = health - amount
	if health <= 0:
		health = 0
		
		get_tree().change_scene("res://scenes/GameOver.tscn")
		# TODO: Game Over
		pass
