extends Node2D
class_name Level

func _ready():
	get_tree().call_group("characters", "connect", "collided", self, "characterCollision")
	
func characterCollision(object, character):	
	if character.is_in_group("enemy") and object.is_in_group("player"):
		character.attack()
