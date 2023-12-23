extends Node2D
@export var animatedSprite : AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	animatedSprite.play("default")
