extends Control

@onready var story_rect: TextureRect = $MarginContainer/story_rect

func _ready() -> void:
	CoreGameplayMusic.stop()
	MenuMusic.stop()
	if (GameManager.is_story_mode or GameManager.is_casual_mode) and GameManager.current_level == 10:
		load_ending()
		%OutroMusic.play()
	elif GameManager.is_tutorial:
		load_tutorial_image()
		%IntroMusic.play()
	else:
		load_story_image()
		%IntroMusic.play()


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
	if GameManager.reward_level_array[9] == 2:
		%market_sign.set_frame_and_progress(2,0.0)
	elif GameManager.reward_level_array[9] == 1:
		%market_sign.set_frame_and_progress(1,0.0)
	else:
		%market_sign.set_frame_and_progress(3,0.0)

	if(GameManager.is_casual_mode):
		if(GameManager.ending_type == 2):
			story_rect.texture = load("res://Assets/Graphics/cutscenes/cutscene_end_casual_local.png")
		elif(GameManager.ending_type == 3):
			story_rect.texture = load("res://Assets/Graphics/cutscenes/cutscene_end_casual_neutral.png")
		else:
			story_rect.texture = load("res://Assets/Graphics/cutscenes/cutscene_end_casual_convenientional.png")
	else:
		if(GameManager.ending_type == 2):
			story_rect.texture = load("res://Assets/Graphics/cutscenes/cutscene_end_challenge_local.png")
		elif(GameManager.ending_type == 3):
			story_rect.texture = load("res://Assets/Graphics/cutscenes/cutscene_end_challenge_neutral.png")
		else:
			story_rect.texture = load("res://Assets/Graphics/cutscenes/cutscene_end_challenge_convenientional.png")
