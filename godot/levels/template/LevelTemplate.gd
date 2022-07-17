extends Node2D
class_name LevelTemplate

export(Resource) onready var level_score

func _ready():
	get_tree().call_group("characters", "connect", "collided", self, "character_collision")
	get_tree().call_group("traps", "connect", "collided", self, "trap_collision")

	GlobalGame.init($Player/Camera2D, $Player)

func trap_collision(character, object):
	character_collision(object, character)

func character_collision(object, character):
	if character is Player:
		if object.is_in_group("traps"):
			character.hit()

func _unhandled_input(event):
	if event is InputEventKey:
		# Restart level on CTRL+R
		if event.pressed and event.scancode == KEY_R and event.control:
			GlobalGame.reload_level()
