extends Control

@onready var story_rect: TextureRect = $MarginContainer/story_rect

func _ready() -> void:
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
	if event.is_action_pressed("advance_story"):
		GameManager.load_level(1)
