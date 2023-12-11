extends Node2D

@onready var sprite = get_node("Sprite2D")
@onready var bulletMarker = get_node("Sprite2D/BulletMarker")
@onready var bulletEffectAnimator = get_node("Sprite2D/BulletMarker/BulletEffect/AnimatedSprite2D")
var owner_node = null
var cooldown = 1.0
var baseCooldown = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	bulletEffectAnimator.visible = false
	bulletEffectAnimator.connect("animation_finished", _on_animation_finished)
	pass # Replace with function body.

func create_bullet(delta):
	if cooldown <= 0:
		shoot()
		cooldown = baseCooldown
	else:
		cooldown -= delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	updateGuns()
	create_bullet(delta)

func updateGuns():
	var targetGlobalPosition = getTarget()
	var gunToTarget = (targetGlobalPosition - global_position).normalized()
	var angle = Vector2(0, 0).angle_to_point(gunToTarget)
	rotation = angle
	rotate_gun()

func rotate_gun():
	if abs(rotation) > PI/2:
		if sprite.flip_v == false:
			bulletMarker.position += Vector2(0, 2)
			sprite.flip_v = true
	else:
		if sprite.flip_v == true:
			sprite.flip_v = false
			bulletMarker.position -= Vector2(0, 2)

func getTarget():
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	if enemies.is_empty():
		return get_global_mouse_position()
	else:
		var target = enemies[0].global_position
		var dist = owner_node.global_position.distance_to(target)
		for i in range(enemies.size()):
			var newDist = owner_node.global_position.distance_to(enemies[i].global_position)
			if newDist <= dist:
				target = enemies[i].global_position
				dist = newDist
		return target

func shoot():
	var bullet = load("res://Guns/bullet_gun_1.tscn").instantiate()
	owner_node.add_sibling(bullet)
	bullet.transform = bulletMarker.global_transform
	create_shoot_animation()

func create_shoot_animation():
	bulletEffectAnimator.visible = true
	bulletEffectAnimator.play("bullet_effect")

func _on_animation_finished():
	bulletEffectAnimator.stop()
	bulletEffectAnimator.visible = false

func set_owner_node(owner):
	owner_node = owner
