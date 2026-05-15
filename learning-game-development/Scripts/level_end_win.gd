extends Control

@onready var next_level: Button = $MarginContainer/VBoxContainer/next_level
@onready var back: Button = $MarginContainer/VBoxContainer/back
@onready var capybara: AnimatedSprite2D = $background/capybara

func level_win_type():
	pass


func _ready() -> void:
	if(GameManager.win_type == 0):
		capybara.set_frame_and_progress(2,0)
	else:
		capybara.set_frame_and_progress(1,0)
	if(not GameManager.is_tutorial):
		show_rewards()
		%textbox.visible = false
	else:
		%textbox.visible = true
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
		GameManager.reset_rewards()
		get_tree().change_scene_to_file("res://Scenes/menus/level_select.tscn")


func _on_back_pressed() -> void:
	if GameManager.is_story_mode:
		# Go back to main menu in story mode
		get_tree().change_scene_to_file("res://Scenes/menus/main_menu.tscn")
	else:
		# Go back to level select in free play
		get_tree().change_scene_to_file("res://Scenes/menus/level_select.tscn")

func show_rewards():
	var rewards = [
		%reward_level_1,
		%reward_level_2,
		%reward_level_3,
		%reward_level_4,
		%reward_level_5,
		%reward_level_6,
		%reward_level_7,
		%reward_level_8,
		%reward_level_9,
		%reward_level_10
	]

	for i in range(rewards.size()):
		var reward = rewards[i]

		reward.set_frame_and_progress(
			GameManager.reward_level_array[i],
			0.0
		)

		# Start invisible
		reward.modulate.a = 0.0

		var tween = create_tween()

		# Small stagger so they appear one by one
		tween.tween_interval(i * 0.1)

		tween.tween_property(
			reward,
			"modulate:a",
			1.0,
			0.3
		)
