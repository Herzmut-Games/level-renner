extends KinematicBody2D

export var chase_velocity = Vector2(50.0, 0)
export var walk_velocity = Vector2(30, 0)
export var gravity_line = 190

var velocity = walk_velocity
var player = null

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum States{CHASE, WALK, ATTACK}
var state = null

func gravity_dir():
	if position.y < gravity_line:
		return Vector2.DOWN
	else:
		return Vector2.UP

func _physics_process(delta):
	$RayCastLeft.cast_to.y = abs($RayCastLeft.cast_to.y) * gravity_dir().y
	$RayCastRight.cast_to.y = abs($RayCastRight.cast_to.y) * gravity_dir().y
	
	if is_on_floor():
		velocity.y = 0
		chase() || walk()
	else:
		velocity += Vector2(0, gravity) * gravity_dir() * delta
		
	move_and_slide(velocity, -gravity_dir())
	
func _process(delta):
	$AnimatedSprite.flip_h = velocity.x < 0
	$AnimatedSprite.flip_v = position.y > gravity_line
	
	match state:
		States.WALK:
			$AnimatedSprite.play("walk")
			$AnimatedSprite.speed_scale = 1.0
		States.CHASE:
			$AnimatedSprite.play("walk")
			$AnimatedSprite.speed_scale = 1.5
	
func chase():
	if !player:
		return false
	
	var directionToPlayer = position.direction_to(player.position)
		
	if directionToPlayer.x < 0 && !$RayCastLeft.is_colliding():
		velocity = Vector2.ZERO
	elif directionToPlayer.x > 0 && !$RayCastRight.is_colliding():
		velocity = Vector2.ZERO
	else:
		velocity = directionToPlayer * chase_velocity
		
	state = States.CHASE
	return true
	
func walk():
	if !$RayCastLeft.is_colliding():
		velocity = walk_velocity * Vector2.RIGHT
	elif !$RayCastRight.is_colliding() :
		velocity = walk_velocity * Vector2.LEFT
		
	state = States.WALK

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.playing = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body:Node):
	player = body
	pass # Replace with function body.


func _on_Area2D_body_exited(_body:Node):
	player = null
	pass # Replace with function body.
