extends Node2D

@onready var deathSound = get_node("AudioStreamPlayer2D")
@onready var animatedSprite = get_node("AnimatedSprite2D")

func _ready():
	animatedSprite.z_index = -99
	deathSound.play()
	animatedSprite.play("death")

func _process(delta):
	modulate.a -= delta / 4.0
	if (!deathSound.playing && !animatedSprite.is_playing()):
		queue_free()

func play_animation(animation, is_flipped_h, new_scale):
	animatedSprite.play(animation)
	animatedSprite.flip_h = is_flipped_h
	animatedSprite.scale = new_scale
