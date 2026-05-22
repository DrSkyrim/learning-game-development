extends Control

@onready var play: Button = $MarginContainer/VBoxContainer/Play
@onready var credits: Button = $MarginContainer/VBoxContainer/Credits
@onready var exit: Button = $MarginContainer/VBoxContainer/Exit
@onready var story_mode: Button = $"MarginContainer/VBoxContainer/Story Mode"
@onready var tutorial: Button = $MarginContainer/VBoxContainer/Tutorial
@onready var casual: Button =$"MarginContainer/VBoxContainer/Casual Mode"


func _ready() -> void:
	CoreGameplayMusic.stop()
	GameManager.is_casual_mode = false
	GameManager.is_story_mode = false

	if not MenuMusic.playing:
		MenuMusic.play()

	var buttons = [play, credits, exit, story_mode, tutorial, casual]

	for btn in buttons:
		if btn:
			btn.pressed.connect(UiClick.play)

	story_mode.pressed.connect(_on_story_pressed)
	play.pressed.connect(_on_play_pressed)
	exit.pressed.connect(_on_exit_pressed)
	tutorial.pressed.connect(_on_tutorial_pressed)
	credits.pressed.connect(_on_credits_pressed)


	# Hide exit button on web builds
	if OS.get_name() == "Web":
		exit.visible = false


func _on_story_pressed():
	if(GameManager.has_played_tutorial):
		GameManager.start_story_mode()
	else:
		get_tree().change_scene_to_file("res://Scenes/menus/tutorial_prompt.tscn")


func _on_play_pressed():
	GameManager.start_free_play()


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_tutorial_pressed():
	GameManager.start_tutorial()


func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Scenes/menus/credits.tscn")
	
func _on_casual_pressed():
	GameManager.is_casual_mode = true
	if(GameManager.has_played_tutorial):
		GameManager.start_casual_mode()
	else:
		get_tree().change_scene_to_file("res://Scenes/menus/tutorial_prompt.tscn")
