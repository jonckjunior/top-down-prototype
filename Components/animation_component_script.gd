extends AnimatedSprite2D
class_name AnimationComponent

var isLookingRight : bool = true
var runningAnimation : String = "running"
var idleAnimation : String = "idle"
var hurtAnimation : String = "hurt"

func take_damage():
	play(hurtAnimation)

func handleAnimation(directionToLook : Vector2):
	if animation == hurtAnimation && is_playing():
		return
	
	if directionToLook == null:
		play(idleAnimation)
		return

	if directionToLook.x > 0:
		isLookingRight = true
	elif directionToLook.x < 0:
		isLookingRight = false
	
	play(runningAnimation)
	
	if isLookingRight:
		flip_h = false
	else:
		flip_h = true
