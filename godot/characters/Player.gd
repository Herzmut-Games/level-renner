extends Character
class_name Player

export var walk_force = 600
export var jump_speed = 200
export var stop_force = 1300
export var walk_max_speed = 200
export var wall_jump_enabled = false
export var wall_jump_bounce = 0.9


onready var inverion_material = ShaderMaterial.new()
onready var hit_sound = preload("res://assets/sound/Hit_2.wav")
onready var audio_player = $AudioStreamPlayer

func _ready():
	inverion_material.shader = preload("res://assets/shaders/color_inversion.gdshader")
	._ready()

func spin_dir():
	$AnimatedSprite.material = null if $AnimatedSprite.material else inverion_material
	.spin_dir()

func process_animation():
	.process_animation()

	match state:
		States.IDLE:
			$AnimatedSprite.play("idle")
		States.RUN:
			$AnimatedSprite.play("run")
		States.FALL:
			$AnimatedSprite.play("fall")
		States.JUMP:
			$AnimatedSprite.play("jump")
		States.HIT:
			$AnimatedSprite.play("hit")

func process_movement(delta):
	var direction = get_movement_direction()
	var walk = walk_force * direction
	if abs(walk) < walk_force * 0.2 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, stop_force * delta)
	else:
		velocity.x += walk * delta
	velocity.x = clamp(velocity.x, -walk_max_speed, walk_max_speed)

	if is_on_floor() or is_on_ceiling():
		velocity.y = 0
	if is_on_wall():
		velocity.x = clamp(velocity.x, -1, 1)
	if !is_on_floor():
		velocity += Vector2(0, gravity) * gravity_dir() * delta

	if  Input.is_action_just_pressed("jump"):
		jump()

	change_state()

func change_state():
	if state == States.HIT:
		return
	if velocity.length() > 0:
		if velocity.normalized().dot(-gravity_dir()) > 0.1:
			state = States.JUMP
		elif velocity.normalized().dot(gravity_dir()) > 0.1:
			state = States.FALL
		elif abs(velocity.x) > 0:
			state = States.RUN
	else:
		state = States.IDLE

func get_movement_direction() -> float:
	return Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

func jump():
	if is_on_floor(): #regular jump
		velocity += gravity_dir() * -jump_speed
	elif wall_jump_enabled and is_on_wall() and no_walljump == 0 and GlobalGame.walljump_available(): #wall jump
		velocity = Vector2((-1 if velocity.x > 0 else 1) * walk_max_speed * wall_jump_bounce, 0) + gravity_dir() * -jump_speed / 1.25
		GlobalGame.use_walljump()

# To prevent race conditions when toggling true/false to set if walljumps are
# enabled, we add/substract 1 for every area we enter or leave, so no_walljump
# will be > 0 if transitioning between two protected areas
var no_walljump = 0

func enable_walljump():
	no_walljump -= 1

func disable_walljump():
	no_walljump += 1



func _on_HitboxArea2d_body_entered(body):
	if body.is_in_group("spike"):
		audio_player.stream = hit_sound
		audio_player.play()
		state = States.HIT

func _on_HitboxArea2d_body_exited(body):
	state = States.IDLE # Replace with function body.
