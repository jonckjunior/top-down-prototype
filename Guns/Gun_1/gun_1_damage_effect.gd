extends Node2D

@onready var animatedSprite = get_node("AnimatedSprite2D")

func _ready():
	animatedSprite.z_index = 1
	animatedSprite.play("default")
	

func _process(_delta):
	if !animatedSprite.is_playing():
		queue_free()
