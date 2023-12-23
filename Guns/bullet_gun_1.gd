extends Area2D

const speed = 750
const damage = 10
var pierced = 1
var bulletImpactEffect = null
var bulletTextEffect = null
var modifiers : PlayerModifier = null
var camera: Camera2D

func _ready():
	add_to_group("projectile")
	modifiers = get_parent().get_node("PlayerModifiers")
	camera = get_parent().get_node("PlayerCamera")

func _physics_process(delta):
	position += transform.x * speed * delta

func delete_projectile():
	queue_free()

func loadImpactEffect(newBulletImpactEffect):
	bulletImpactEffect = newBulletImpactEffect

func loadTextEffect(newBulletTextEffect):
	bulletTextEffect = newBulletTextEffect

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		if pierced > 0:
			create_impact_effect(global_position)
			body.take_damage(get_damage())
			body.knockback(body.global_position - global_position, 10)
			if camera != null:
				camera.add_trauma(0.15)
			pierced -= 1

		if pierced <= 0:
			delete_projectile()

func get_damage() -> int: 
	return int(damage * modifiers.damageModifier)

func create_impact_effect(pos):
	if bulletImpactEffect == null:
		return
	var effectInstance = bulletImpactEffect.instantiate()
	var textInstance = bulletTextEffect.instantiate()
	textInstance.set_text(str(get_damage()))
	add_sibling(effectInstance)
	add_sibling(textInstance)
	effectInstance.global_position = pos
	textInstance.global_position = pos
