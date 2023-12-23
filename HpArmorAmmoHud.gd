extends Sprite2D


@export var player : Cyborg
@export var playerModifier : PlayerModifier
@onready var life = get_node("Life")
@onready var damage = get_node("Damage")
@onready var reload = get_node("Reload")

var playerStats = null

func _ready():
	playerStats = player.get_node("PlayerStats")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	life.text = str(playerModifier.healthModifier + playerStats.playerLife) if playerStats != null else "DEAD"
	damage.text = "%.2f" % playerModifier.damageModifier
	reload.text = "%.2f" % playerModifier.speedModifier
