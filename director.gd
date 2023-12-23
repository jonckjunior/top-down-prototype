extends Node2D

@export var upgradeMenu : Control
@export var upgradeSound: AudioStreamPlayer2D

var playerExperience = 0
var playerLevel = 0
var experienceRequired = [40, 80, 120, 160, 200]

func handle_enemy_death(experience: int):
	playerExperience += experience
	if experienceRequired.size() == playerLevel:
		experienceRequired.append(experienceRequired[playerLevel-1] * 1.2)
	if playerExperience >= experienceRequired[playerLevel]:
		upgradeSound.play()
		playerLevel += 1
		upgradeMenu.activate_menu()
