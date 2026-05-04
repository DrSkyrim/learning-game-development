extends Control

@onready var next_level: Button = $MarginContainer/VBoxContainer/next_level
@onready var back: Button = $MarginContainer/VBoxContainer/back



func _ready() -> void:
	next_level.pressed.connect(_on_next_pressed)
	back.pressed.connect(_on_back_pressed)
	next_level.disabled = not GameManager.is_story_mode && not GameManager.is_tutorial

func _on_next_pressed() -> void:
	if GameManager.is_story_mode:
		GameManager.load_next_level()
	elif GameManager.is_tutorial:
		GameManager.load_next_tutorial()
	else:
		# In free play, "next" doesn't really make sense
		get_tree().change_scene_to_file("res://Scenes/menus/level_select.tscn")


func _on_back_pressed() -> void:
	if GameManager.is_story_mode:
		# Go back to main menu in story mode
		get_tree().change_scene_to_file("res://Scenes/menus/main_menu.tscn")
	else:
		# Go back to level select in free play
		get_tree().change_scene_to_file("res://Scenes/menus/level_select.tscn")
