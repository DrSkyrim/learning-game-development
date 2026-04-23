extends Control

@onready var retry: Button = $MarginContainer/VBoxContainer/retry

@onready var back: Button = $MarginContainer/VBoxContainer/back



func _ready() -> void:
	retry.pressed.connect(_on_retry_pressed)
	back.pressed.connect(_on_back_pressed)

func _on_retry_pressed() -> void:
	if GameManager.current_level > 0:
		GameManager.load_level(GameManager.current_level)
	else:
		get_tree().reload_current_scene()


func _on_back_pressed() -> void:
	if GameManager.is_story_mode:
		# Go back to main menu in story mode
		get_tree().change_scene_to_file("res://Scenes/menus/main_menu.tscn")
	else:
		# Go back to level select in free play
		get_tree().change_scene_to_file("res://Scenes/menus/level_select.tscn")
