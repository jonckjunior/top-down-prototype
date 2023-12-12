extends CharacterBody2D

@onready var animationPlayer = get_node("AnimationPlayer")
@onready var cameraNode = owner.get_node("PlayerCamera")
@onready var gunPositions = [get_node("GunPosition_0"), get_node("GunPosition_1")]
var playerGuns = []
var isLookingRight = true
var playerLife = 10

const SPEED = 100
const ACCELERATION = 500
const FRICTION = 800

func _ready():
	createGuns()

func _process(delta):
	#playerGun.lookAt(get_global_mouse_position())
	updateCamera()

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	var normalized_direction = direction.normalized()
	
	if normalized_direction != Vector2.ZERO:
		velocity = velocity.move_toward(normalized_direction * SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	handleAnimation()
	move_and_collide(velocity * delta)

func createGuns():
	for n in range(gunPositions.size()):
		var playerGunRaw = load("res://Guns/Gun_1/gun_1.tscn")
		playerGuns.append(playerGunRaw.instantiate())
		playerGuns[n].position = gunPositions[n].position
		gunPositions[n].add_child(playerGuns[n])
		playerGuns[n].set_owner_node(self)


func handleAnimation():
	if velocity.x > 0:
		isLookingRight = true
	elif velocity.x < 0:
		isLookingRight = false
	
	if velocity != Vector2.ZERO:
		if isLookingRight:
			animationPlayer.play("running_right")
		else:
			animationPlayer.play("running_left")
	else:
		if isLookingRight:
			animationPlayer.play("idle_right")
		else:
			animationPlayer.play("idle_left")

func updateCamera():
	cameraNode.position = position

func take_damage(dmg):
	playerLife -= dmg
	print(playerLife)
	knockback()

func knockback():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for i in range(enemies.size()):
		var direction = enemies[i].global_position - global_position
		if direction.length() < 100:
			enemies[i].knockback(direction, 100)
