extends KinematicBody2D
class_name Character

export var chase_velocity = Vector2(50.0, 0)
export var roam_velocity = Vector2(30, 0)
export var gravity_line = 190

var velocity = roam_velocity
var player = null

signal collided(object, player)

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum States{CHASE, ROAM, ATTACK}
var state = States.ROAM

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("characters")
	$AnimatedSprite.connect("animation_finished", self, "_on_animation_finished")

func gravity_dir():
	if position.y < gravity_line:
		return Vector2.DOWN
	else:
		return Vector2.UP

func _physics_process(delta):
	processMovement(delta)
		
	move_and_slide(velocity, -gravity_dir())
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision:
			emit_signal("collided", collision.collider, self)
			
func processMovement(delta):
	pass
	
func _process(delta):
	processAnimation()
	
func spin_dir():
	$Tween.interpolate_property($AnimatedSprite, "rotation_degrees", 0, 180, 0.15)
	$Tween.start()
	yield($Tween, "tween_completed")
	$AnimatedSprite.rotation_degrees = 0
		
func processAnimation():
	if position.y > gravity_line != $AnimatedSprite.flip_v :
		spin_dir()

	$AnimatedSprite.flip_h = velocity.x < 0
	$AnimatedSprite.flip_v = position.y > gravity_line
		
func roam():
	player = null
	velocity = roam_velocity
	state = States.ROAM
	
func chase(body: Node):
	player = body
	state = States.CHASE
	
func attack():
	state = States.ATTACK
	
func _on_animation_finished():
	if state == States.ATTACK:
		roam()
