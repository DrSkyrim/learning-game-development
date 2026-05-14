extends Control

@onready var play: Button = $MarginContainer/VBoxContainer/Play
@onready var options: Button = $MarginContainer/VBoxContainer/Options
@onready var exit: Button = $MarginContainer/VBoxContainer/Exit
@onready var story_mode: Button = $"MarginContainer/VBoxContainer/Story Mode"
@onready var tutorial: Button = $MarginContainer/VBoxContainer/Tutorial

func _ready() -> void:
	CoreGameplayMusic.stop()
	
	if not MenuMusic.playing:
		MenuMusic.play()
	
	var buttons = [play, options, exit, story_mode, tutorial]
	for btn in buttons:
		if btn: 
			btn.pressed.connect(UiClick.play)
		
	story_mode.pressed.connect(_on_story_pressed)
	play.pressed.connect(_on_play_pressed)
	exit.pressed.connect(_on_exit_pressed)
	tutorial.pressed.connect(_on_tutorial_pressed)

func _on_story_pressed():
	GameManager.start_story_mode()

func _on_play_pressed():
	GameManager.start_free_play()

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_tutorial_pressed():
	GameManager.start_tutorial()
