extends CharacterBody2D

@onready var animationPlayer = get_node("Sprite2D/AnimatedSprite2D")
@onready var gunPositions = [get_node("GunPosition_0"), get_node("GunPosition_1"), get_node("GunPosition_2"), get_node("GunPosition_3")]
var playerGuns = []
var isLookingRight = true
var playerLife = 10

const SPEED = 100
const ACCELERATION = 500
const FRICTION = 800

signal player_take_damage(cur_life, max_life)

func _ready():
	createGuns()

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	var normalized_direction = direction.normalized()
	
	if normalized_direction != Vector2.ZERO:
		velocity = velocity.move_toward(normalized_direction * SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	handleAnimation()
	move_and_collide(velocity * delta)
	update_gun_position()

func createGuns():
	for n in range(gunPositions.size()):
		var playerGunRaw = load("res://Guns/Gun_1/gun_1.tscn")
		playerGuns.append(playerGunRaw.instantiate())
		gunPositions[n].add_child(playerGuns[n])
		playerGuns[n].owner = owner


func handleAnimation():
	if "hurt" in animationPlayer.animation && animationPlayer.is_playing():
		return
	
	if velocity.x > 0:
		animationPlayer.flip_h = false
	elif velocity.x < 0:
		animationPlayer.flip_h = true
	
	if velocity != Vector2.ZERO:
		animationPlayer.play("running")
	else:
		animationPlayer.play("idle")
	

func take_damage(dmg):
	playerLife -= dmg
	player_take_damage.emit(playerLife, 10)
	animationPlayer.play("hurt")
	
	knockback()

func knockback():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for i in range(enemies.size()):
		var direction = enemies[i].global_position - global_position
		if direction.length() < 100:
			enemies[i].knockback(direction, 100)

func update_gun_position():
	for i in range(gunPositions.size()):
		var distance = gunPositions[i].position.length()
		var newAngle = gunPositions[i].position.angle() + PI / 100
		var unitVector = Vector2(cos(newAngle), sin(newAngle))
		gunPositions[i].global_position = global_position + unitVector * distance
		playerGuns[i].set_player_position(global_position)
