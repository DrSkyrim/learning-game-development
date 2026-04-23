extends Node2D

@export var moves = 10

signal moves_changed
func _ready():
	# Connect to all baskets
	for node in get_tree().get_nodes_in_group("items"):
		if not node.has_method("get_type"):
			continue
			
		var t = node.get_type()
		
		if t == node.Type.BASKET_ORG or t == node.Type.BASKET_GMO:
			node.moved.connect(_on_basket_moved)


func _process(_delta):
	check_win_condition()


func _on_basket_moved():
	moves -= 1
	emit_signal("moves_changed")
	
	if moves <= 0:
		lose_level()


func check_win_condition():
	var org_exists = false
	var gmo_exists = false

	for node in get_tree().get_nodes_in_group("items"):
		if not node.has_method("get_type"):
			continue

		var t = node.get_type()

		if t == node.Type.FRUIT_ORG:
			org_exists = true
		elif t == node.Type.FRUIT_GMO:
			gmo_exists = true

	# FIXED CONDITION 👇 (your original had a bug)
	if (not org_exists or not gmo_exists) and moves > 0:
		win_level()
		
func get_moves():
	return moves

func win_level():
	print("Level Complete!")

	await get_tree().create_timer(0.5).timeout

	if GameManager.is_story_mode:
		GameManager.load_next_level()
	else:
		get_tree().change_scene_to_file("res://Scenes/menus/level_select.tscn")


func lose_level():
	print("Out of moves!")
	get_tree().change_scene_to_file("res://Scenes/menus/level_select.tscn")
