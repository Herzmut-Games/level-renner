extends KinematicBody2D
class_name Player

export var walk_force = 600
export var jump_speed = 200
export var stop_force = 1300
export var walk_max_speed = 200
export var gravity_line = 190
export var gravity_boost = 1.05
export var wall_jump_enabled = false
export var wall_jump_cooldown = 0.5
export var wall_jump_bounce = 0.9

var velocity = Vector2()
var looking_right = true
var upside_down = false
var wall_jump_used = false
var gravity_boosted = false

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
onready var anim_player = $AnimationPlayer
onready var anim_sprite = $AnimatedSprite
onready var walljump_timer = $WalljumpCooldownTimer

func trigger_walljump_cooldown():
	wall_jump_used = true
	walljump_timer.start(wall_jump_cooldown)

func _on_WalljumpCooldownTimer_timeout():
	wall_jump_used = false

func get_movement_direction() -> float:
	return Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

func look_dir(should_look_right: bool) -> void:
	if should_look_right == looking_right: return
	anim_sprite.scale.x *= -1
	looking_right = not looking_right

# spin the character
func spin_dir() -> void:
  # inintial rotation degrees
	var rot_deg = 0
	$Tween.interpolate_property(anim_sprite, "rotation_degrees", rot_deg, rot_deg + 180, 0.15)
	$Tween.start()
	yield($Tween, "tween_completed")
	# reset rotation degrees, as they are only needed for the animation
	anim_sprite.rotation_degrees = rot_deg
	# invert scale to flip the sprite
	anim_sprite.scale.y *= -1
	upside_down = anim_sprite.scale.y < 0

func _physics_process(delta) -> void:
	var next_animation = "idle"
	var direction = get_movement_direction()
	# player should get a small speed boost when swapping gravity
	var gravity_switched = false

	if (position.y >= gravity_line) == (gravity > 0):
		spin_dir()
		gravity *= -1
		gravity_switched = true

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

	if !is_on_floor() and anim_player.current_animation != "jump":
		next_animation = "fall"

	velocity.y += gravity * delta

	if gravity_switched and not gravity_boosted:
		velocity *= gravity_boost
		gravity_boosted = true

	velocity = move_and_slide_with_snap(
		velocity,
		Vector2.DOWN if not upside_down else Vector2.UP,
		Vector2.UP if not upside_down else Vector2.DOWN
	)

  # regular jump
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = (1 if upside_down else -1) * jump_speed
		wall_jump_used = false
		gravity_boosted = false
		anim_player.play("jump")
		yield(anim_player, "animation_finished")
		anim_player.play("fall")

  # wall jump
	if (Input.is_action_just_pressed("jump") and wall_jump_enabled and
		not is_on_floor() and is_on_wall() and not wall_jump_used and GlobalGame.walljump_available()):
		velocity.y = (1 if upside_down else -1) * jump_speed / 1.25
		velocity.x += (-1 if looking_right else 1) * walk_max_speed * wall_jump_bounce
		trigger_walljump_cooldown()
		GlobalGame.use_walljump()

	# adapt next_animation if the current animation is not "jump" or already the next_animation
	if not anim_player.current_animation in ["jump", next_animation]:
		anim_player.play(next_animation)


