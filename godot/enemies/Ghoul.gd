extends KinematicBody2D

var chase_velocity = Vector2(50.0, 0)
var walk_velocity = Vector2(30, 0)

var velocity = Vector2.ZERO
var player = null
var looking_right = true

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func look_dir(should_look_right: bool) -> void:
	if should_look_right == looking_right: return
	$AnimatedSprite.scale.x *= -1
	looking_right = not looking_right

func can_walk() -> bool:
	return $RayCastLeft.is_colliding() || $RayCastRight.is_colliding()
	
func _physics_process(delta):
	if is_on_floor():
		velocity.y = 0
		chase() || walk()
	else:
		velocity += Vector2(0, gravity) * delta
		
	look_dir(velocity.x > 0)
				
	move_and_slide(velocity, Vector2.UP)
	
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
		
	$AnimatedSprite.play("walk")
	return true
	
func walk():		
	if !$RayCastLeft.is_colliding():
		velocity = walk_velocity * Vector2.RIGHT
	elif !$RayCastRight.is_colliding() :
		velocity = walk_velocity  * Vector2.LEFT
		
	$AnimatedSprite.play("walk")


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
