extends Enemy

export var chase_velocity = Vector2(50.0, 0)
export var roam_velocity = Vector2(30, 0)

func process_animation():
	.process_animation()

	match state:
		States.ROAM:
			$AnimatedSprite.play("walk")
			$AnimatedSprite.speed_scale = 1.0
			$AnimatedSpriteOverworld.play("walk")
			$AnimatedSpriteOverworld.speed_scale = 1.0
		States.CHASE:
			$AnimatedSprite.play("walk")
			$AnimatedSprite.speed_scale = 1.5
			$AnimatedSpriteOverworld.play("walk")
			$AnimatedSpriteOverworld.speed_scale = 1.5
		States.ATTACK:
			$AnimatedSprite.play("attack")
			$AnimatedSpriteOverworld.play("attack")
		States.DIE:
			$AnimatedSprite.play("die")
			$AnimatedSpriteOverworld.play("die")
			
func process_state():
	if state == States.DIE:
		if $AnimatedSprite.visible:
			yield($AnimatedSprite, "animation_finished")
		if $AnimatedSpriteOverworld.visible:
			yield($AnimatedSpriteOverworld, "animation_finished")
		queue_free()
	if state == States.ATTACK:
		if $AnimatedSprite.visible:
			yield($AnimatedSprite, "animation_finished")
		if $AnimatedSpriteOverworld.visible:
			yield($AnimatedSpriteOverworld, "animation_finished")
	if $Attack.get_attack_target() != null and $Attack.use():
		pass
	elif get_chase_target() != null:
		state = States.CHASE
	else:
		state = States.ROAM

func process_movement(_delta):
	$RayCastLeft.cast_to.y = abs($RayCastLeft.cast_to.y) * gravity_dir().y
	$RayCastRight.cast_to.y = abs($RayCastRight.cast_to.y) * gravity_dir().y
	
	if is_on_floor():
		match state:
			States.CHASE:
				process_chase()
			States.ROAM:
				process_roam()
				
func get_chase_target():
	var chase_bodies = $TriggerArea.get_overlapping_bodies()
	if len(chase_bodies) == 0:
		return null
	return chase_bodies[0]
	
func process_chase():
	var chase_target = get_chase_target()
	if chase_target == null:
		return
		
	var directionToTarget = position.direction_to(chase_target.position)
		
	if directionToTarget.x < 0 && !$RayCastLeft.is_colliding():
		velocity = Vector2.ZERO
	elif directionToTarget.x > 0 && !$RayCastRight.is_colliding():
		velocity = Vector2.ZERO
	else:
		velocity = directionToTarget * chase_velocity
	
func process_roam():
	if !$RayCastLeft.is_colliding() or is_on_wall():
		velocity = roam_velocity * Vector2.RIGHT
	elif !$RayCastRight.is_colliding() or is_on_wall() :
		velocity = roam_velocity * Vector2.LEFT
	elif velocity.length() == 0:
		velocity = roam_velocity
	else:
		velocity = velocity.normalized() * roam_velocity
