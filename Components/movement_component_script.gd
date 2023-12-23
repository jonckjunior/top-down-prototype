extends Node2D
class_name MovementComponent

var baseKnockback = 0.3
var currentKnockback = 0.0
var speedKnockback = 0.0
var knockbackVector = null
const SPEED = 50
const ACCELERATION = 250
const FRICTION = 800
var target = null

func _process(_delta):
	if target == null:
		var arrayOfTargets = get_tree().get_nodes_in_group("player")
		if !arrayOfTargets.is_empty():
			target = arrayOfTargets[0]

func get_target_position() -> Vector2:
	if target != null:
		return target.global_position
	else:
		return get_global_mouse_position()

func knockback(knockbackDirection, knockbackSpeed):
	if knockbackSpeed > speedKnockback:
		currentKnockback = baseKnockback
		knockbackVector = knockbackDirection
		speedKnockback = knockbackSpeed

func getNormalizedDirection() -> Vector2:
	if currentKnockback <= 0:
		var direction = (get_target_position() - global_position)
		var normalized_direction = direction.normalized()
		return normalized_direction
	else:
		return knockbackVector.normalized()
	

func getNormalizedDelta(direction, delta) -> float:
	if currentKnockback <= 0:
		if direction != Vector2.ZERO:
			return ACCELERATION * delta
		else:
			return FRICTION * delta
	else:
		return speedKnockback

func getNormalizedSpeed():
	if currentKnockback <= 0:
		return SPEED
	else:
		return speedKnockback

func getVelocity(delta) -> Vector3:
	updateKnockback(delta)
	
	var normalized_direction = getNormalizedDirection()
	var normalized_delta = getNormalizedDelta(normalized_direction, delta)
	var normalized_speed = getNormalizedSpeed()
	
	var normalizedVector = normalized_direction * normalized_speed
	return Vector3(normalizedVector.x, normalizedVector.y, normalized_delta)

func updateKnockback(delta):
	currentKnockback -= delta
	if currentKnockback < 0:
		currentKnockback = 0
		speedKnockback = 0
