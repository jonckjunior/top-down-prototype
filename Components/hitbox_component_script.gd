extends Area2D
class_name HitboxComponent

@export var healthComponent: HealthComponent
@export var attackComponent: AttackComponent

func _ready():
	body_entered.connect(_on_area_2d_body_entered)

func damage(attack):
	if healthComponent:
		healthComponent.damage(attack)

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(attackComponent.attack)
