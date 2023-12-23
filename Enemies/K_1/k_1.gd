extends CharacterBody2D

@onready var attackComponent : AttackComponent = get_node("AttackComponent")
@onready var healthComponent : HealthComponent = get_node("HealthComponent")
@onready var hitboxComponent : HitboxComponent = get_node("HitboxComponent")
@onready var movementComponent : MovementComponent = get_node("MovementComponent")
@onready var animationComponent : AnimationComponent = get_node("AnimationComponent")

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
	var target = movementComponent.get_target_position()
	return target - global_position

func take_damage(dmg):
	hitboxComponent.damage(dmg)

func knockback(knockbackDirection, knockbackSpeed):
	movementComponent.knockback(knockbackDirection, knockbackSpeed)
