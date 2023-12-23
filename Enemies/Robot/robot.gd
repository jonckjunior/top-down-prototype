extends CharacterBody2D

@onready var attackComponent : AttackComponent = get_node("AttackComponent")
@onready var healthComponent : HealthComponent = get_node("HealthComponent")
@onready var hitboxComponent : HitboxComponent = get_node("HitboxComponent")
@onready var movementComponent : MovementComponent = get_node("MovementComponent")
@onready var animationComponent : AnimationComponent = get_node("AnimationComponent")
var baseExp = 10

signal enemy_died(exp: int)

func _ready():
	add_to_group("enemy")

func _physics_process(delta):
	updateVelocity(delta)
	animationComponent.handleAnimation(get_direction_to_target())

func updateVelocity(delta):
	var vec3 = movementComponent.getVelocity(delta)
	velocity = velocity.move_toward(Vector2(vec3.x, vec3.y), vec3.z)
	move_and_collide(velocity * delta)

func get_direction_to_target() -> Vector2:
	var targetGlobalPosition = movementComponent.get_target_position()
	return targetGlobalPosition - global_position

func take_damage(dmg):
	hitboxComponent.damage(dmg)
	animationComponent.take_damage()
	if healthComponent.health <= 0:
		die()

func knockback(knockbackDirection, knockbackSpeed):
	movementComponent.knockback(knockbackDirection, knockbackSpeed)

func die():
	var deathObject = load("res://Enemies/Robot/robot_death.tscn")
	var deathInstance = deathObject.instantiate()
	get_parent().add_child(deathInstance)
	deathInstance.global_position = global_position
	giveExp()
	# object dies on their own

func giveExp():
	enemy_died.emit(baseExp)
