extends Node2D

var spawnerPositions : Array
var noiseArray : Array
var cameraSize : Vector2
@onready var timer : Timer = get_node("Timer")
@onready var enemyRaw = load("res://Enemies/Robot/robot.tscn")
@export var playerCamera : Camera2D
var firstEnemy = true

func _ready():
	for i in range(4):
		spawnerPositions.append(get_node("Spawner%d" % i))
		noiseArray.append(Vector2(0,0))
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = 2
	timer.start()

func _process(_delta):
	for i in range(4):
		spawnerPositions[i].global_position = global_position
	
	cameraSize = playerCamera.get_viewport_rect().size / playerCamera.zoom
	var top_left = playerCamera.get_screen_center_position() - cameraSize / 2
	var top_right = top_left + Vector2(cameraSize.x, 0)
	var bottom_left = top_left + Vector2(0, cameraSize.y)
	var bottom_right = top_left + cameraSize
	
	spawnerPositions[0].global_position = top_left + Vector2(cameraSize.x/2, 0)
	spawnerPositions[1].global_position = top_right + Vector2(0, cameraSize.y/2)
	spawnerPositions[2].global_position = bottom_right - Vector2(cameraSize.x/2, 0)
	spawnerPositions[3].global_position = bottom_left - Vector2(0, cameraSize.y/2)
	timer.wait_time = 4.5

func _on_timer_timeout():
	spawn_enemy()

func spawn_enemy():
	var enemy = enemyRaw.instantiate()
	add_sibling(enemy)
	enemy.enemy_died.connect(get_parent().handle_enemy_death)

	var cameraX = int(cameraSize.x)
	var cameraY = int(cameraSize.y)
	
	noiseArray[0] = Vector2(randi()%cameraX - cameraX/2.0, 0)
	noiseArray[1] = Vector2(0, randi()%cameraY - cameraY/2.0)
	
	
	var spawnerIndex = randi() % spawnerPositions.size()
	var noisePosition = noiseArray[spawnerIndex % 2]
	
	enemy.global_position = spawnerPositions[spawnerIndex].global_position + noisePosition
