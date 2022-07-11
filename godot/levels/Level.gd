extends Node2D
class_name Level

func _ready():
	get_tree().call_group("characters", "connect", "collided", self, "character_collision")
	get_tree().call_group("traps", "connect", "collided", self, "trap_collision")

	GlobalGame.init($Player/Camera2D, $Player)

func trap_collision(character, object):
	character_collision(object, character)

func character_collision(object, character):
	if character is Player:
		if object is Enemy:
			object.attack(character)
			character.hit()
		if object.is_in_group("traps"):
			character.hit()
