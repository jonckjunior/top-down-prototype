extends Area2D

const speed = 750
const damage = 2
var pierced = 1

func _ready():
	add_to_group("projectile")

func _physics_process(delta):
	position += transform.x * speed * delta

func delete_projectile():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("enemy"):
		if pierced > 0:
			body.take_damage(damage)
			body.knockback(body.global_position - global_position, 10)
			pierced -= 1

		if pierced <= 0:
			delete_projectile()
