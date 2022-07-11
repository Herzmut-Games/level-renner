extends Node
class_name Skill

export(NodePath) var character_path
onready var character: Character = get_node(character_path)

func use():
	pass
