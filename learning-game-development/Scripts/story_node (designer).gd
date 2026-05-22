extends Control

@onready var story_rect: TextureRect = $MarginContainer/story_rect

func _ready() -> void:
	# Stop other persistent background musics
	MenuMusic.stop()
	CoreGameplayMusic.stop()

	if (not GameManager.is_tutorial):
		# --- STORY CUTSCENES ---
		match GameManager.story_index:
			0, 1, 2:
				CutsceneMusic.play() # Plays music for story sequences
				
		load_story_image()
	else:
		# --- TUTORIAL CUTSCENE ---
		CutsceneMusic.play() # Plays music for tutorial screen
		load_tutorial_image()


func load_story_image():
	var path = get_story_path()
	if path == "":
		return
		
	var texture = load(path)
	if texture:
		story_rect.texture = texture
		
func get_story_path() -> String:
	return GameManager.get_story_image_path()

func _input(event):
	if event.is_action_pressed("advance_story"):
		CutsceneMusic.stop() # Stop cutscene music before changing scene
		
		if GameManager.is_tutorial:
			GameManager.load_tutorial_level(GameManager.current_tutorial_level)
		else:
			GameManager.load_level(GameManager.current_level)

func load_tutorial_image():
	var path = "res://Assets/Graphics/cutscenes/cutscene_tutorial.png"
	var texture = load(path)
	if texture:
		story_rect.texture = texture
