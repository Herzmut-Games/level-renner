extends KinematicBody2D

var run_speed = 50
var velocity = Vector2.ZERO
var player = null
var looking_right = true

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func look_dir(should_look_right: bool) -> void:
	if should_look_right == looking_right: return
	$AnimatedSprite.scale.x *= -1
	looking_right = not looking_right

func can_walk() -> bool:
	if !player:
		return false
	var player_direction = position.direction_to(player.position)

	if player_direction.x > 0:
		return $RayCastRight.is_colliding()
	return $RayCastLeft.is_colliding()

func _physics_process(delta):
	velocity = Vector2.ZERO

	if can_walk():
		velocity = position.direction_to(player.position) * Vector2(1, 0) * run_speed
		$AnimatedSprite.play("walk")
	else:
		$AnimatedSprite.play("idle")

	velocity.y += gravity * delta
	velocity = move_and_slide(velocity)

	# look in a different direction
	if velocity.x:
		look_dir(velocity.x > 0)
		$AnimatedSprite.play("walk")
	else:
		$AnimatedSprite.play("idle")

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
