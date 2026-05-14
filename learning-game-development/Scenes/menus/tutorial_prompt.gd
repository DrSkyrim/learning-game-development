extends Control
@onready var yes: Button = $MarginContainer/VBoxContainer/HBoxContainer/yes
@onready var no: Button = $MarginContainer/VBoxContainer/HBoxContainer/no


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	yes.pressed.connect(_on_yes_pressed)
	no.pressed.connect(_on_no_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_yes_pressed():
	GameManager.start_tutorial()

func _on_no_pressed():
	GameManager.start_story_mode()
