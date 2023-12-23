extends CharacterBody2D

@onready var animationPlayer = get_node("Sprite2D/AnimatedSprite2D")
@onready var deathObjectRaw = load("res://Enemies/Demon/death_object.tscn")
@export var life = 10

var baseKnockback = 0.3
var currentKnockback = 0.0
var speedKnockback = 0.0
var knockbackVector = null
var target = null
var isLookingRight = true
const SPEED = 50
const ACCELERATION = 250
const FRICTION = 800
const damage = 1

func _ready():
	var arrayOfTargets = get_tree().get_nodes_in_group("player")
	target = arrayOfTargets[0]

func take_damage(dmg):
	#TODO(jonck): remover esse codigo bunda
	var dir = (target.global_position - global_position)
	var isLookingUp = (dir.y > 0)
	if isLookingUp:
		animationPlayer.play("kobold_damage_down_left")
	else:
		animationPlayer.play("kobold_damage_top_left")

	if isLookingRight: animationPlayer.flip_h = true
	else: animationPlayer.flip_h = false
	
	
	
	life -= dmg
	if life <= 0:
		die()

func _physics_process(delta):
	updateVelocity(delta)
	handleAnimation()

func handleAnimation():
	if "damage" in animationPlayer.animation && animationPlayer.is_playing():
		return
	
	var dir = (target.global_position - global_position)

	if dir.x > 0:
		isLookingRight = true
	elif dir.x < 0:
		isLookingRight = false
	
	var isLookingUp = (dir.y > 0)
	
	if isLookingUp:
		animationPlayer.play("kobold_running_down_left")
	else:
		animationPlayer.play("kobold_running_top_left")
	
	
	
	if isLookingRight:
		animationPlayer.flip_h = true
		#animationPlayer.play("running_right")
	else:
		animationPlayer.flip_h = false
		#animationPlayer.play("running_left")

func knockback(knockbackDirection, knockbackSpeed):
	if knockbackSpeed > speedKnockback:
		currentKnockback = baseKnockback
		knockbackVector = knockbackDirection
		speedKnockback = knockbackSpeed

func die():
	var deathObject = deathObjectRaw.instantiate()
	owner.add_child(deathObject)
	
	deathObject.global_position = global_position
	
	var dir = target.global_position - global_position
	var animationName = "kobold_death_down_left" if (dir.y > 0) else "kobold_death_top_left"
	deathObject.play_animation(animationName, animationPlayer.flip_h, animationPlayer.scale)

	queue_free()

func getNormalizedDirection():
	if currentKnockback <= 0:
		var direction = (target.global_position - global_position)
		var normalized_direction = direction.normalized()
		return normalized_direction
	elif currentKnockback > 0:
		return knockbackVector.normalized()

func getNormalizedDelta(direction, delta):
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

func updateVelocity(delta):
	updateKnockback(delta)
	
	var normalized_direction = getNormalizedDirection()
	var normalized_delta = getNormalizedDelta(normalized_direction, delta)
	var normalized_speed = getNormalizedSpeed()
	
	velocity = velocity.move_toward(normalized_direction * normalized_speed, normalized_delta)
	move_and_collide(velocity * delta)

func updateKnockback(delta):
	currentKnockback -= delta
	if currentKnockback < 0:
		currentKnockback = 0
		speedKnockback = 0


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage)
