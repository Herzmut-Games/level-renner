extends KinematicBody2D
class_name Character

export var gravity_line = 0

export var velocity = Vector2.ZERO
export var invincible = false

var target = null

signal collided(object, player)

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum States{IDLE, CHASE, ROAM, ATTACK, RUN, JUMP, FALL, HIT, DASH}
var state = States.ROAM

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("characters")

func gravity_dir():
	if position.y < gravity_line:
		return Vector2.DOWN
	else:
		return Vector2.UP
		
func in_overworld():
	return gravity_dir() == Vector2.DOWN

func in_underworld():
	return !in_overworld()

func _physics_process(delta):
	process_movement(delta)
	move_and_slide_with_snap(velocity, gravity_dir(), -gravity_dir())

	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision:
			emit_signal("collided", collision.collider, self)
			
	if is_on_floor() and in_overworld() or is_on_ceiling() and in_underworld():
		velocity.y = clamp(velocity.y, -INF, 0)
	elif is_on_ceiling() and in_overworld() or is_on_floor() and in_underworld():
		velocity.y = clamp(velocity.y, 0, INF)
	if is_on_wall():
		velocity.x = clamp(velocity.x, -1, 1)
	if !is_on_floor():
		velocity += Vector2(0, gravity) * gravity_dir() * delta

func process_movement(delta):
	pass

func _process(delta):
	process_animation()

	if state == States.ATTACK:
		yield($AnimatedSprite, "animation_finished")
		idle()

func spin_dir():
	$Tween.interpolate_property($AnimatedSprite, "rotation_degrees", 0, 180, .15)
	$Tween.start()
	yield($Tween, "tween_completed")
	$AnimatedSprite.flip_v = not $AnimatedSprite.flip_v
	$AnimatedSprite.rotation_degrees = 0

func process_animation():
	if position.y > gravity_line != $AnimatedSprite.flip_v and not $Tween.is_active():
		spin_dir()
		
	if in_overworld():
		$AnimatedSpriteOverworld.visible = true
		$AnimatedSprite.visible = false
	else:
		$AnimatedSpriteOverworld.visible = false
		$AnimatedSprite.visible = true

	$AnimatedSprite.flip_h = velocity.x < 0
	$AnimatedSpriteOverworld.flip_h = velocity.x < 0

func idle():
	state = States.IDLE

func attack(node: Node):
	target = node
	state = States.ATTACK
