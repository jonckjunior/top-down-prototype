extends Node2D
class_name Gun
@onready var sprite = get_node("Sprite2D")
@onready var bulletMarker = get_node("Sprite2D/BulletMarker")
@onready var bulletEffectAnimator = get_node("Sprite2D/BulletMarker/BulletEffect/AnimatedSprite2D")
@onready var bulletSound : AudioStreamPlayer2D
@onready var bulletImpactEffect = load("res://Guns/Gun_1/gun_1_damage_effect.tscn")
@onready var bulletTextEffect = load("res://DamageText/damage_text.tscn")
#var cooldown = 1.0
#var baseCooldown = 0.5
var canShoot = false
#var player_position = null
#
#
#func set_player_position(pos):
	#player_position = pos

# Called when the node enters the scene tree for the first time.
func _ready():
	bulletEffectAnimator.visible = false
	bulletEffectAnimator.connect("animation_finished", _on_animation_finished)
	bulletSound = get_node("AudioStreamPlayer2D")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	pass
	#if(Input.is_action_just_pressed("shoot")):
		#shoot()

#func updateGuns():
	#var targetGlobalPosition = getTarget()
	#var gunToTarget = (targetGlobalPosition - global_position).normalized()
	#var angle = Vector2(0, 0).angle_to_point(gunToTarget)
	#rotation = angle
	#rotate_gun()

#func rotate_gun():
	#if abs(rotation) > PI/2:
		#if sprite.flip_v == false:
			#bulletMarker.position += Vector2(0, 2)
			#sprite.flip_v = true
	#else:
		#if sprite.flip_v == true:
			#sprite.flip_v = false
			#bulletMarker.position -= Vector2(0, 2)

#func getTarget():
	#var enemies = get_tree().get_nodes_in_group("enemy")
	#
	#if enemies.is_empty():
		#return get_global_mouse_position()
	#else:
		#var target = enemies[0].global_position
		#var dist = getDistanceTo(target)
		#for i in range(enemies.size()):
			#var newDist = getDistanceTo(enemies[i].global_position)
			#if newDist <= dist:
				#target = enemies[i].global_position
				#dist = newDist
		#return target

#func getDistanceTo(target) -> float:
	#if player_position != null:
		#return player_position.distance_to(target)
	#else:
		#return get_parent().global_position.distance_to(target)

func shoot():
	var bullet = load("res://Guns/bullet_gun_1.tscn").instantiate()
	bullet.transform = bulletMarker.global_transform
	# TODO(jonck): arrumar essa palhaçada 
	get_parent().owner.add_sibling(bullet)
	bulletSound.play()
	bullet.loadImpactEffect(bulletImpactEffect)
	bullet.loadTextEffect(bulletTextEffect)
	create_shoot_animation()

func create_shoot_animation():
	bulletEffectAnimator.visible = true
	bulletEffectAnimator.play("bullet_effect")

func _on_animation_finished():
	bulletEffectAnimator.stop()
	bulletEffectAnimator.visible = false

func set_can_shoot(flag):
	canShoot = flag
