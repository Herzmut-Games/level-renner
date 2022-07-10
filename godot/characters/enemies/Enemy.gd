extends "res://characters/Character.gd"
class_name Enemy


export var chase_velocity = Vector2(50.0, 0)
export var roam_velocity = Vector2(30, 0)

func roam():
	target = null
	velocity = roam_velocity
	state = States.ROAM

func chase(body: Node):
	target = body
	state = States.CHASE
