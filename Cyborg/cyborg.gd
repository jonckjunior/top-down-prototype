extends CharacterBody2D
class_name Cyborg
@export var animationPlayer : AnimationPlayer
@export var playerStats: PlayerStats
@export var animatedSprite: AnimatedSprite2D
@export var leftArmSprite: Sprite2D
@export var rightArmSprite: Sprite2D
@export var leftGunPosition: Marker2D
@export var rightGunPosition: Marker2D
@export var visionMarker: Marker2D
@export var playerModifiers: PlayerModifier
@onready var playerDamageParticles = load("res://particles/player_damage.tscn")
@onready var playerDeathScene = load("res://Cyborg/cyborg_death_scene.tscn")


var playerGuns: Array[Gun]
const hurtAnimation = "hurt"
var rightArmOffset = 0.567232
var isTimeSlowing = null

func _ready():
	rightArmOffset = rightArmSprite.rotation
	add_to_group("player")
	create_guns()
	#die()

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	var normalized_direction = direction.normalized()
	
	if normalized_direction != Vector2.ZERO:
		velocity = velocity.move_toward(normalized_direction * playerStats.SPEED, playerStats.ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, playerStats.FRICTION * delta)

	update_cooldown(delta)
	move_and_collide(velocity * delta)
	handleAnimation()
	process_shoot()
	
	if isTimeSlowing == true:
		Engine.time_scale -= min(0.009, Engine.time_scale)
		if Engine.time_scale <= 0:
			isTimeSlowing = false
			Engine.time_scale = 0.1
	elif isTimeSlowing == false:
		Engine.time_scale += min(0.01, Engine.time_scale)
		if Engine.time_scale > 1:
			Engine.time_scale = 1
			isTimeSlowing = null

func create_guns():
	var normalGunRaw = load("res://Guns/Gun_1/gun_1.tscn")
	var leftGun = normalGunRaw.instantiate()
	var rightGun = normalGunRaw.instantiate()
	rightGun.rotation = -rightArmOffset
	rightGun.z_index = 5
	rightGun.z_as_relative = false
	rightGun.position.y -= 2
	
	leftGunPosition.add_child(leftGun)
	rightGunPosition.add_child(rightGun)
	playerGuns.append(leftGun)
	playerGuns.append(rightGun)
	
	rightGun.set_can_shoot(true)

func handleAnimation():
	if animationPlayer.current_animation == hurtAnimation && animationPlayer.is_playing():
		return
	
	var target = get_global_mouse_position()
	var dirVector = target - visionMarker.global_position
	#
	if dirVector.x > 0:
		animatedSprite.scale.x = 1
	elif dirVector.x < 0:
		animatedSprite.scale.x = -1

	if velocity != Vector2.ZERO:
		animationPlayer.play("running")
	else:
		animationPlayer.play("idle")
	
	update_gun_positions()

func update_gun_positions():
	var target = get_global_mouse_position()
	var unitVector = (target - visionMarker.global_position).normalized()
	var vectorAngle = Vector2(0, 0).angle_to_point(unitVector)
	
	if abs(vectorAngle) < PI/2:
		leftArmSprite.rotation = vectorAngle
		rightArmSprite.rotation = vectorAngle + rightArmOffset
	else:
		var newAngle = Vector2(0,0).angle_to_point(unitVector * Vector2(-1, 1))
		
		leftArmSprite.rotation = newAngle
		rightArmSprite.rotation = newAngle + rightArmOffset

func take_damage(dmg):
	var particles = playerDamageParticles.instantiate()
	add_child(particles)
	particles.global_position = global_position
	particles.one_shot = true
	
	playerStats.playerLife -= dmg
	knockback()
	
	if playerStats.playerLife <= 0:
		die()

func knockback():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for i in range(enemies.size()):
		var direction = enemies[i].global_position - global_position
		if direction.length() < 100:
			enemies[i].knockback(direction, 100)

func update_cooldown(delta):
	playerStats.cooldownGun -= delta
	if playerStats.cooldownGun <= 0:
		playerStats.cooldownGun = 0

func process_shoot():
	if(Input.is_action_pressed("shoot")):
		for i in range(playerGuns.size()):
			if playerGuns[i].canShoot && playerStats.cooldownGun <= 0:
				playerGuns[i].shoot()
				playerGuns[i].set_can_shoot(false)
				var nxt = (i + 1) % playerGuns.size()
				playerGuns[nxt].set_can_shoot(true)
				playerStats.cooldownGun = playerStats.cooldownBase / playerModifiers.speedModifier
				break

func die():
	var playerDeath = playerDeathScene.instantiate()
	add_sibling(playerDeath)
	playerDeath.global_position = global_position
	queue_free()
