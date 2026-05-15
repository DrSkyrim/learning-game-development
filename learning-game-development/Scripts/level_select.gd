extends Node

@onready var grid = $MarginContainer/VBoxContainer/LevelMapping
@onready var back: Button = $MarginContainer/VBoxContainer/Back

var total_levels := 10  # change this to however many levels you have

func _ready():
	CoreGameplayMusic.stop()

	if not MenuMusic.playing:
		MenuMusic.play()
	populate_levels()
	back.pressed.connect(_on_back_pressed)

func populate_levels():

	for i in range(total_levels):
		var level_id = i + 1

		var button = Button.new()
		button.flat = true
		button.custom_minimum_size = Vector2(64, 64)

		var path = ("res://Assets/Graphics/UI/level select menu/button_level%d.png" % level_id)
		if ResourceLoader.exists(path):
			button.icon = load(path)
		else:
			print("Missing icon:", path)

		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		button.pressed.connect(_on_level_button_pressed.bind(level_id))

		grid.add_child(button)
		
func _on_level_button_pressed(level_id):
	var level_path = "res://scenes/levels/level_%d.tscn" % level_id
	var scene = load(level_path)
	GameManager.is_story_mode = false
	GameManager.load_level(level_id)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/menus/main_menu.tscn")
