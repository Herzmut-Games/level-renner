extends Character
class_name Player

export var walk_force_ground = 800
export var walk_force_air = 800

export var stop_force_ground = 1800
export var stop_force_air = 1500

export var stop_force_speed_cap_ground = 5000
export var stop_force_speed_cap_air = 3000

export var speed_cap_ground = 200
export var speed_cap_air = 200

onready var hit_sound = preload("res://assets/sound/Hit_2.wav")
onready var audio_player = $AudioStreamPlayer

var camExtScript = preload("res://utils/CamShake.gd").new()

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
		States.DASH:
			$AnimatedSprite.play("dash")
			$AnimatedSpriteOverworld.play("dash")
		States.ATTACK:
			$AnimatedSprite.play("attack")
			$AnimatedSpriteOverworld.play("attack")

func walk_force():
	if is_on_floor():
		return walk_force_ground
	else:
		return walk_force_air
			
func stop_force():
	if is_on_floor():
		return stop_force_ground
	else:
		return stop_force_air
		
func speed_cap():
	if is_on_floor():
		return speed_cap_ground
	else:
		return speed_cap_air
		
func stop_force_speed_cap():
	if is_on_floor():
		return stop_force_speed_cap_ground
	else:
		return stop_force_speed_cap_air
		
func velocity_x_direction():
	return 1 if velocity.x >= 0 else -1

func process_movement(delta):
	var direction = get_movement_direction()
	var walk = walk_force() * direction
	if state != States.DASH:
		if (                                                      # stop when
			(is_on_floor() and abs(walk) < walk_force() * 0.2) or # on floor and no walk butten is pressed
			velocity.x * walk < 0                                 # or direction changed
		):
			velocity.x = move_toward(velocity.x, 0, stop_force() * delta)
		else:
			velocity.x += walk * delta
	
		if abs(velocity.x) > speed_cap():
			velocity.x = move_toward(
				velocity.x, 
				velocity_x_direction() * speed_cap(), 
				stop_force_speed_cap() * delta
			)

func process_state():
	if state == States.ATTACK or state == States.DASH:
		if $AnimatedSprite.visible:
			yield($AnimatedSprite, "animation_finished")
		if $AnimatedSpriteOverworld.visible:
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
	
func hit():
	if !.hit():
		return
	audio_player.stream = hit_sound
	audio_player.play()
	
	# only ignore the damage, we want to know if we were hit, just not die
	if not invincible:
		GlobalGame.hit()

func die():
	get_tree().paused = true
	$Tween.interpolate_property($Camera2D, "zoom", $Camera2D.zoom, Vector2(.1, .1), .5)
	$Tween.interpolate_property($Camera2D, "global_position", $Camera2D.global_position, global_position, 1)
	$Tween.start()
	yield($Tween, "tween_completed")
	$AnimatedSprite.show()
	$AnimatedSpriteOverworld.hide()
	$AnimationPlayer.play("die")
	yield($AnimationPlayer, "animation_finished")
	$Camera2D/DeathMenu.show()
