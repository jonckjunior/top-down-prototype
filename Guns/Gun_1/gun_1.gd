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
func _process(delta):
	if abs(rotation) > PI/2:
		sprite.flip_v = true
	else:
		sprite.flip_v = false
	create_bullet(delta)

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
