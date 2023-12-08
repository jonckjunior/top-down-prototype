extends CharacterBody2D

@onready var _animated_sprite = get_node("Sprite2D/AnimatedSprite2D")

const SPEED = 100
const ACCELERATION = 500
const FRICTION = 800


func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	var normalized_direction = direction.normalized()
	
	if normalized_direction != Vector2.ZERO:
		velocity = velocity.move_toward(normalized_direction * SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	#velocity = normalized_direction * SPEED
	
	handleAnimation()
	
	print(move_and_slide())


func handleAnimation():
	if velocity.x > 0:
		_animated_sprite.play("running_right")
	elif velocity.x < 0:
		_animated_sprite.play("running_left")
	else:
		_animated_sprite.play("idle_right")
	print(_animated_sprite.animation)
