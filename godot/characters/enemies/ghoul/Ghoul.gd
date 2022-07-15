extends Enemy

func _ready():
	._ready()
	var _error = $TriggerArea.connect("body_entered", self, "_on_chase_trigger_entered")
	_error = $TriggerArea.connect("body_exited", self, "_on_chase_trigger_exited")
	
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

func process_movement(_delta):
	$RayCastLeft.cast_to.y = abs($RayCastLeft.cast_to.y) * gravity_dir().y
	$RayCastRight.cast_to.y = abs($RayCastRight.cast_to.y) * gravity_dir().y
	
	if is_on_floor():
		match state:
			States.CHASE:
				process_chase()
			States.ROAM:
				process_roam()
			States.ATTACK:
				process_attack()
	
func process_chase():
	if !target:
		return
	
	var directionToPlayer = position.direction_to(target.position)
		
	if directionToPlayer.x < 0 && !$RayCastLeft.is_colliding():
		velocity = Vector2.ZERO
	elif directionToPlayer.x > 0 && !$RayCastRight.is_colliding():
		velocity = Vector2.ZERO
	else:
		velocity = directionToPlayer * chase_velocity
	
func process_roam():
	if !$RayCastLeft.is_colliding() or is_on_wall():
		velocity = roam_velocity * Vector2.RIGHT
	elif !$RayCastRight.is_colliding() or is_on_wall() :
		velocity = roam_velocity * Vector2.LEFT
	else:
		velocity = velocity.normalized() * roam_velocity
		
func process_attack():
	velocity = Vector2(target.position.x - position.x, 0).normalized()
		
func idle():
	roam()
		
func _on_chase_trigger_entered(body:Node):
	chase(body)

func _on_chase_trigger_exited(_body:Node):
	roam()
