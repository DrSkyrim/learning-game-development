extends Control

@onready var story_rect: TextureRect = $MarginContainer/story_rect

func _ready() -> void:
	if (GameManager.is_story_mode or GameManager.is_casual_mode) and GameManager.current_level == 10:
		load_ending()
	elif GameManager.is_tutorial:
		load_tutorial_image()
	else:
		load_story_image()


func load_story_image():
	var path = get_story_path()

	if path == "":
		print("No story image found")
		return

	var texture = load(path)

	if texture:
		story_rect.texture = texture
	else:
		print("Failed to load: ", path)
		
func get_story_path() -> String:
	return GameManager.get_story_image_path()

func _input(event):
	if not event.is_action_pressed("advance_story"):
		return

	# Tutorial → continue tutorial
	if GameManager.is_tutorial:
		GameManager.load_tutorial_level(
			GameManager.current_tutorial_level
		)

	# Ending → back to menu
	elif GameManager.current_level == 10:
		get_tree().change_scene_to_file(
			"res://Scenes/menus/main_menu.tscn"
		)

	# Normal story intro/cutscenes → start game
	else:
		GameManager.load_level(1)

func load_tutorial_image():
	var path = "res://Assets/Graphics/cutscenes/cutscene_tutorial.png"

	if path == "":
		print("No story image found")
		return

	var texture = load(path)

	if texture:
		story_rect.texture = texture
	else:
		print("Failed to load: ", path)

func load_ending():
	if(GameManager.is_casual_mode):
		if(GameManager.ending_type == 1):
			story_rect.texture = load("res://Assets/Graphics/cutscenes/cutscene_end_casual_local.png")
		elif(GameManager.ending_type == 2):
			story_rect.texture = load("res://Assets/Graphics/cutscenes/cutscene_end_casual_neutral.png")
		else:
			story_rect.texture = load("res://Assets/Graphics/cutscenes/cutscene_end_casual_convenientional.png")
	else:
		if(GameManager.ending_type == 1):
			story_rect.texture = load("res://Assets/Graphics/cutscenes/cutscene_end_challenge_local.png")
		elif(GameManager.ending_type == 2):
			story_rect.texture = load("res://Assets/Graphics/cutscenes/cutscene_end_challenge_neutral.png")
		else:
			story_rect.texture = load("res://Assets/Graphics/cutscenes/cutscene_end_challenge_convenientional.png")
