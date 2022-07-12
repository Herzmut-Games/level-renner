extends Character
class_name Player

export var walk_force = 600
export var stop_force = 1300
export var walk_max_speed = 200

onready var inverion_material = ShaderMaterial.new()
onready var hit_sound = preload("res://assets/sound/Hit_2.wav")
onready var audio_player = $AudioStreamPlayer

var camExtScript = preload("res://utils/CamShake.gd").new()

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
			$AnimatedSpriteOverworld.play("idle")
		States.RUN:
			$AnimatedSprite.play("run")
			$AnimatedSpriteOverworld.play("run")
		States.FALL:
			$AnimatedSprite.play("fall")
			$AnimatedSpriteOverworld.play("fall")
		States.JUMP:
			$AnimatedSprite.play("jump")
			$AnimatedSpriteOverworld.play("jump")
		States.HIT:
			$AnimatedSprite.play("hit")
			$AnimatedSpriteOverworld.play("hit")
		States.DASH:
			$AnimatedSprite.play("jump")
			$AnimatedSpriteOverworld.play("jump")

func process_movement(delta):
	var direction = get_movement_direction()
	var walk = walk_force * direction
	if abs(walk) < walk_force * 0.2 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, stop_force * delta)
	else:
		if velocity.x * walk < 0 and is_on_floor():
			velocity.x = 0
		else:
			velocity.x += walk * delta
	velocity.x = clamp(velocity.x, -walk_max_speed, walk_max_speed)

	change_state()

func change_state():
	if state == States.HIT and $HitTimer.time_left > 0:
		return
	if state == States.DASH:
		yield($AnimatedSprite, "animation_finished")
		yield($AnimatedSpriteOverworld, "animation_finished")
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

# To prevent race conditions when toggling true/false to set if walljumps are
# enabled, we add/substract 1 for every area we enter or leave, so no_walljump
# will be > 0 if transitioning between two protected areas
var no_walljump = 0

func enable_walljump():
	no_walljump -= 1

func disable_walljump():
	no_walljump += 1

func hit():
	if $HitTimer.time_left > 0:
		return

	# only ignore the damage, we want to know if we were hit, just not die
	if not invincible:
		GlobalGame.hit()

	audio_player.stream = hit_sound
	audio_player.play()

	state = States.HIT
	$HitTimer.start(1)
