extends Node2D
class_name Level

func _ready():
	get_tree().call_group("characters", "connect", "collided", self, "characterCollision")
	GlobalGame.start_run()
	
func characterCollision(object, character):	
	if (
		character is Enemy and
		(
			object is Player
		)
	):
		if character is Enemy:
			character.attack()
