extends Enemy

func _ready():
	._ready()
	$TriggerArea.connect("body_entered", self, "_on_chase_trigger_entered")
	$TriggerArea.connect("body_exited", self, "_on_chase_trigger_exited")
	
func processAnimation():
	.processAnimation()
	
	match state:
		States.ROAM:
			$AnimatedSprite.play("walk")
			$AnimatedSprite.speed_scale = 1.0
		States.CHASE:
			$AnimatedSprite.play("walk")
			$AnimatedSprite.speed_scale = 1.5
		States.ATTACK:
			$AnimatedSprite.play("attack")
			
func processMovement(delta):
	$RayCastLeft.cast_to.y = abs($RayCastLeft.cast_to.y) * gravity_dir().y
	$RayCastRight.cast_to.y = abs($RayCastRight.cast_to.y) * gravity_dir().y
	
	if is_on_floor():
		velocity.y = 0
		match state:
			States.CHASE:
				processChase()
			States.ROAM:
				processRoam()
			States.ATTACK:
				velocity.x = 0
	else:
		velocity += Vector2(0, gravity) * gravity_dir() * delta
	
func processChase():
	if !player:
		return
	
	var directionToPlayer = position.direction_to(player.position)
		
	if directionToPlayer.x < 0 && !$RayCastLeft.is_colliding():
		velocity = Vector2.ZERO
	elif directionToPlayer.x > 0 && !$RayCastRight.is_colliding():
		velocity = Vector2.ZERO
	else:
		velocity = directionToPlayer * chase_velocity
	
func processRoam():
	if !$RayCastLeft.is_colliding():
		velocity = roam_velocity * Vector2.RIGHT
	elif !$RayCastRight.is_colliding() :
		velocity = roam_velocity * Vector2.LEFT
	else:
		velocity = velocity.normalized() * roam_velocity
		
func _on_chase_trigger_entered(body:Node):
	chase(body)

func _on_chase_trigger_exited(body:Node):
	roam()
