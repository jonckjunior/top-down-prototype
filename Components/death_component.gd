extends Node2D

@export var deathInstance: Node2D

func die():
	var deathObject = deathInstance.instantiate()
	owner.add_child(deathObject)
	deathObject.global_position = global_position
	deathObject.die()
