extends CharacterBody2D

@export var type : Type
enum Type {FRUIT_ORG, FRUIT_GMO, BASKET_ORG, BASKET_GMO}

signal moved

const TILE_SIZE := 64
const MOVE_SPEED := 300.0

var facing := Vector2.UP
var target_position : Vector2
var is_moving := false

# Cached reference to level (safe lookup)
var level


func _ready():
	target_position = position
	level = find_level()


func _process(delta):
	if is_moving:
		move_to_target(delta)
		return

	var direction := Vector2.ZERO

	# Movement input
	if type == Type.BASKET_ORG:
		direction = get_arrow_input()
	elif type == Type.BASKET_GMO:
		direction = get_wasd_input()

	# Rotation input
	if type == Type.BASKET_ORG:
		if Input.is_action_just_pressed("rotate_organic"):
			rotate_right()
	elif type == Type.BASKET_GMO:
		if Input.is_action_just_pressed("rotate_non_organic"):
			rotate_right()

	if direction != Vector2.ZERO:
		start_move(direction)


# ======================
# INPUT
# ======================

func get_arrow_input() -> Vector2:
	if Input.is_action_just_pressed("ui_right"):
		return Vector2.RIGHT
	if Input.is_action_just_pressed("ui_left"):
		return Vector2.LEFT
	if Input.is_action_just_pressed("ui_down"):
		return Vector2.DOWN
	if Input.is_action_just_pressed("ui_up"):
		return Vector2.UP
	return Vector2.ZERO


func get_wasd_input() -> Vector2:
	if Input.is_action_just_pressed("move_right"):
		return Vector2.RIGHT
	if Input.is_action_just_pressed("move_left"):
		return Vector2.LEFT
	if Input.is_action_just_pressed("move_down"):
		return Vector2.DOWN
	if Input.is_action_just_pressed("move_up"):
		return Vector2.UP
	return Vector2.ZERO


# ======================
# MOVEMENT
# ======================

func start_move(direction: Vector2):
	var motion = direction * TILE_SIZE

	if not test_move(transform, motion):
		target_position = position + motion
		is_moving = true


func move_to_target(delta):
	position = position.move_toward(target_position, MOVE_SPEED * delta)

	if position.distance_to(target_position) < 1:
		position = snap_to_grid(target_position)
		is_moving = false

		if is_basket():
			emit_signal("moved")


# ======================
# ROTATION (SAFE)
# ======================

func rotate_right():
	if not is_basket():
		return

	var old_rotation = rotation_degrees
	var old_facing = facing

	# Apply rotation
	facing = facing.rotated(PI/2)
	rotation_degrees += 90

	# Snap to grid BEFORE checking collision
	position = snap_to_grid(position)

	# Check if rotation causes collision
	if test_move(transform, Vector2.ZERO):
		facing = old_facing
		rotation_degrees = old_rotation


func update_visual_rotation():
	rotation_degrees = round(rotation_degrees / 90.0) * 90.0


# ======================
# COLLECTION
# ======================

func _on_only_use_with_baskets_body_entered(body: Node2D) -> void:
	if not is_basket():
		return

	if body == self:
		return

	if not body.has_method("get_type"):
		return

	var other_type = body.get_type()

	if type == Type.BASKET_ORG and other_type == Type.FRUIT_ORG:
		if level != null and level.has_method("add_moves"):
			level.add_moves(3)
		body.queue_free()

	elif type == Type.BASKET_GMO and other_type == Type.FRUIT_GMO:
		body.queue_free()


# ======================
# HELPERS
# ======================

func is_basket() -> bool:
	return type == Type.BASKET_ORG or type == Type.BASKET_GMO


func snap_to_grid(pos: Vector2) -> Vector2:
	return Vector2(
		round(pos.x / TILE_SIZE) * TILE_SIZE,
		round(pos.y / TILE_SIZE) * TILE_SIZE
	)


func find_level():
	var node = self
	while node != null:
		if node.has_method("add_moves"):
			return node
		node = node.get_parent()
	return null


func get_type():
	return type
