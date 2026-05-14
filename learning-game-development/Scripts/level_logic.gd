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
	if not GameManager.is_tutorial:
		moves -= 1
		emit_signal("moves_changed")
	
		if moves <= 0:
			lose_level()


func check_win_condition():
	var org_exists = false
	var gmo_exists = false
	var org_not_org = 0  #0 = organic, 1 = non

	for node in get_tree().get_nodes_in_group("items"):
		if not node.has_method("get_type"):
			continue

		var t = node.get_type()

		if t == node.Type.FRUIT_ORG:
			org_exists = true
		elif t == node.Type.FRUIT_GMO:
			gmo_exists = true
	if (not org_exists or not gmo_exists) and moves > 0:
		if(not org_exists):
			org_not_org = 0
			win_level(org_not_org)
		else:
			org_not_org = 1
			win_level(org_not_org)
		
func get_moves():
	return moves
	
func add_moves(amount:int):
	moves += amount
	print("Moves after bonus: ", moves)

func win_level(org_not_org):
	print("Level Complete!")

	await get_tree().create_timer(0.5).timeout
	if(GameManager.is_tutorial):
		if(org_not_org == 0):
			get_tree().change_scene_to_file("res://Scenes/menus/level_end_win_local.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/menus/level_end_win_local.tscn")
	else:
		var this_level = GameManager.current_level-1
		if(org_not_org == 0):
			GameManager.reward_level_array[this_level] = 2
		else:
			GameManager.reward_level_array[this_level] = 1
		get_tree().change_scene_to_file("res://Scenes/menus/level_end_win_result.tscn")


func lose_level():
	await get_tree().create_timer(0.5).timeout

	get_tree().change_scene_to_file("res://Scenes/menus/level_end_loss.tscn")
