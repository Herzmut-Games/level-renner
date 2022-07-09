extends KinematicBody2D
class_name Player

export var walk_force = 600
export var jump_speed = 200
export var stop_force = 1300
export var walk_max_speed = 200
export var wall_jump_enabled = false

var velocity = Vector2()
var looking_right = true
var wall_jump_used = false

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func get_movement_direction() -> float:
	return Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

func look_dir(should_look_right: bool) -> void:
	if should_look_right == looking_right: return
	$AnimatedSprite.scale.x *= -1
	looking_right = not looking_right

func _physics_process(delta) -> void:
	var next_animation = "idle"
	var direction = get_movement_direction()

	if !is_on_floor() and $AnimatedSprite.animation != "jump":
		next_animation = "fall"

	var walk = walk_force * direction
	if abs(walk) < walk_force * 0.2 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, stop_force * delta)
	else:
		velocity.x += walk * delta
	velocity.x = clamp(velocity.x, -walk_max_speed, walk_max_speed)

	# look in a different direction
	if velocity.x:
		look_dir(velocity.x > 0)
		next_animation = "run"
	
	velocity.y += gravity * delta

	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)

	# regular jump
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_speed
		wall_jump_used = false
		$AnimatedSprite.play("jump")
		yield($AnimatedSprite, "animation_finished")
		$AnimatedSprite.play("fall")

	# wall jump
	if (Input.is_action_just_pressed("jump") and wall_jump_enabled and
		not is_on_floor() and is_on_wall() and not wall_jump_used):
		velocity.y = - jump_speed / 1.25
		velocity.x += (1 if looking_right else -1) * walk_max_speed
		wall_jump_used = true

	# adapt next_animation if the current animation is not "jump" or already the next_animation
	if not $AnimatedSprite.animation in ["jump", next_animation]:
		$AnimatedSprite.play(next_animation)
