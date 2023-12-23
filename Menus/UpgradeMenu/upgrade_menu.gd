extends Control

@export var firstChoice: Button
@export var secondChoice: Button
@export var thirdChoice: Button
@export var playerModifier: PlayerModifier
@export var canvasModulate: CanvasModulate
@export var player: Cyborg
var isActivated : bool = false

func _ready():
	firstChoice.pressed.connect(_on_first_upgrade_selected)
	secondChoice.pressed.connect(_on_second_upgrade_selected)
	thirdChoice.pressed.connect(_on_third_upgrade_selected)

func activate_menu():
	isActivated = true

func _process(_delta):
	if isActivated:
		Engine.time_scale -= min(0.003, Engine.time_scale)
		canvasModulate.color -= Color(0.001, 0.001, 0.001, 0)

		if Engine.time_scale == 0:
			Engine.time_scale = 1
			get_tree().paused = true
			show()
			isActivated = false

func _on_first_upgrade_selected():
	if playerModifier == null: return
	playerModifier.speedModifier *= 1.1
	deactivate_menu()

func _on_second_upgrade_selected():
	if playerModifier == null: return
	playerModifier.damageModifier *= 1.1
	deactivate_menu()

func _on_third_upgrade_selected():
	if playerModifier == null: return
	player.playerStats.playerLife += 1
	deactivate_menu()

func deactivate_menu():
	get_tree().paused = false
	canvasModulate.color = Color(1, 1, 1, 1)
	hide()
