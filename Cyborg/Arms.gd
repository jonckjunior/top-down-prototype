extends Node2D

@export var leftArmSprite: Sprite2D
@export var rightArmSprite: Sprite2D
var rightArmOffset = 0

func _ready():
	rightArmOffset = rightArmSprite.rotation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_gun_positions()


func update_gun_positions():
	var target = get_global_mouse_position()
	var unitVector = (target - get_parent().global_position).normalized()
	var vectorAngle = Vector2(0, 0).angle_to_point(unitVector)
	leftArmSprite.rotation = vectorAngle
	rightArmSprite.rotation = vectorAngle + rightArmOffset
	#rotate_gun(leftArmSprite)
	#rotate_gun(rightArmSprite)

func rotate_gun(armSprite):
	if abs(armSprite.rotation) > PI/2:
		if armSprite.flip_v == false:
			#bulletMarker.position += Vector2(0, 2)
			armSprite.flip_v = true
	else:
		if armSprite.flip_v == true:
			armSprite.flip_v = false
			#bulletMarker.position -= Vector2(0, 2)
