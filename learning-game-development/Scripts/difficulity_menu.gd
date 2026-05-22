extends Control

@onready var casual: Button = $MarginContainer/VBoxContainer/Casual
@onready var challenge: Button = $MarginContainer/VBoxContainer/Challenge


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	casual.pressed.connect(_on_casual_pressed)
	challenge.pressed.connect(_on_challenge_pressed)
	
func _on_casual_pressed():
	GameManager.is_casual_mode = true
	GameManager.start_casual_mode()

func _on_challenge_pressed():
	GameManager.is_story_mode = true
	GameManager.start_story_mode()
