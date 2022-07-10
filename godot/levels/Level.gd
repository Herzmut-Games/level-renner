extends Node2D
class_name Level

func _ready():
	get_tree().call_group("characters", "connect", "collided", self, "character_collision")
	GlobalGame.init($Level/Player/Camera2D, $Level/Player)
	
func character_collision(object, character):
	if (
		character is Enemy and
		(
			object is Player
		)
	):
		if character is Enemy:
			character.attack()
