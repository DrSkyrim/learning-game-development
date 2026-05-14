extends Control

@onready var story_rect: TextureRect = $MarginContainer/story_rect

func _ready() -> void:
	if (not GameManager.is_tutorial):
		load_story_image()
	else:
		load_tutorial_image()


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
	if event.is_action_pressed("advance_story"):
		if GameManager.is_tutorial:
			GameManager.load_tutorial_level(GameManager.current_tutorial_level)
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
