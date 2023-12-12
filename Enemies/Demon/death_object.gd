extends Node2D

var deathSound = null
var animatedSprite = null

func _ready():
	deathSound = get_node("AudioStreamPlayer2D")
	animatedSprite = get_node("AnimatedSprite2D")
	deathSound.play()

func _process(delta):
	if !deathSound.playing && !animatedSprite.is_playing():
		queue_free()

func play_animation(animation, is_flipped_h, scale):
	animatedSprite.play(animation)
	animatedSprite.flip_h = is_flipped_h
	animatedSprite.scale = scale
