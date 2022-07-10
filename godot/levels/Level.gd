extends Node2D
class_name Level

func _ready():
	get_tree().call_group("characters", "connect", "collided", self, "character_collision")
	get_tree().call_group("traps", "connect", "collided", self, "character_collision")
	
	GlobalGame.init($Level/Player/Camera2D, $Level/Player)
	
func character_collision(character, object):
	if character is Player:
		if object is Enemy:
			object.attack(object)
			character.hit()
		if object is Trap:
			character.hit()
