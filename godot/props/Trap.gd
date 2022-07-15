extends Node2D
class_name Trap

signal collided(player, object)

func _ready():
	add_to_group("traps")
	var _error = $Area2D.connect("body_entered", self, "trigger")

func trigger(body: Node):
	emit_signal("collided", body, self)
