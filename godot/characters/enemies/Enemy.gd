extends "res://characters/Character.gd"
class_name Enemy

export var hp = 1

func hit():
	if !.hit():
		return
	
	hp -= 1
	if hp <= 0:
		state = States.DIE
		self.collision_mask &= 0b11111111111111111111111111111101
