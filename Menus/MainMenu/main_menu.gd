extends Control

func _ready():
	var startButton = get_node("VBoxContainer/StartButton")
	var optionsButton = get_node("VBoxContainer/OptionsButton")
	var quitButton = get_node("VBoxContainer/QuitButton")
	
	startButton.pressed.connect(_on_startButton_pressed)
	quitButton.pressed.connect(_on_quitButton_pressed)
	
	startButton.grab_focus()


func _on_startButton_pressed():
	get_tree().change_scene_to_file("res://game_master.tscn")

func _on_quitButton_pressed():
	get_tree().quit()
