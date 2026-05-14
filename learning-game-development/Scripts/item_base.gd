extends CharacterBody2D

@export var type : Type
enum Type {FRUIT_ORG, FRUIT_GMO, BASKET_ORG, BASKET_GMO}
@export var uses_rotation := false

signal moved

const TILE_SIZE := 64
const MOVE_SPEED := 300.0

var facing := Vector2.UP
var target_position : Vector2
var is_moving := false

# Swipe
var swipe_start := Vector2.ZERO
var swipe_end := Vector2.ZERO
var swipe_threshold := 30.0

# Selection (shared across all baskets)
static var selected_basket: CharacterBody2D = null

var level


func _ready():
	target_position = position
	level = find_level()


func _process(delta):
	if is_moving:
		move_to_target(delta)


# ======================
# INPUT
# ======================

func _input(event):
	if not is_basket():
		return

	# SELECT on press
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if is_mouse_over():
			if selected_basket != null and selected_basket != self:
				selected_basket.scale = Vector2.ONE

			selected_basket = self
			selected_basket.scale = Vector2(1.1, 1.1)
			swipe_start = event.position

	# TOUCH select
	elif event is InputEventScreenTouch and event.pressed:
		if is_touch_over(event.position):
			if selected_basket != null and selected_basket != self:
				selected_basket.scale = Vector2.ONE

			selected_basket = self
			selected_basket.scale = Vector2(1.1, 1.1)
			swipe_start = event.position
	# RELEASE → swipe
	elif event is InputEventMouseButton and not event.pressed:
		if selected_basket == self:
			swipe_end = event.position
			handle_swipe()

	elif event is InputEventScreenTouch and not event.pressed:
		if selected_basket == self:
			swipe_end = event.position
			handle_swipe()


func handle_swipe():
	if is_moving:
		return

	var delta = swipe_end - swipe_start

	# TAP → ROTATE
	if delta.length() < swipe_threshold:
		rotate_right()
		return

	var direction = get_swipe_direction(delta)

	if direction != Vector2.ZERO:
		start_move(direction)


func get_swipe_direction(delta: Vector2) -> Vector2:
	if abs(delta.x) > abs(delta.y):
		return Vector2.RIGHT if delta.x > 0 else Vector2.LEFT
	else:
		return Vector2.DOWN if delta.y > 0 else Vector2.UP


# ======================
# HIT DETECTION
# ======================

func is_mouse_over() -> bool:
	var mouse_pos = get_global_mouse_position()
	var shape_node = $CollisionShape2D

	var local_pos = shape_node.to_local(mouse_pos)

	var rect_shape = shape_node.shape as RectangleShape2D
	if rect_shape:
		var extents = rect_shape.size / 2.0
		return abs(local_pos.x) <= extents.x and abs(local_pos.y) <= extents.y

	return false


func is_touch_over(pos: Vector2) -> bool:
	var shape_node = $CollisionShape2D
	var local_pos = shape_node.to_local(pos)

	var rect_shape = shape_node.shape as RectangleShape2D
	if rect_shape:
		var extents = rect_shape.size / 2.0
		return abs(local_pos.x) <= extents.x and abs(local_pos.y) <= extents.y

	return false


func get_collision_shape():
	return $CollisionShape2D.shape


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
# ROTATION
# ======================

func rotate_right():
	if not is_basket() or not uses_rotation:
		return

	var old_rotation = rotation_degrees
	var old_facing = facing

	facing = facing.rotated(PI/2)
	rotation_degrees += 90

	position = snap_to_grid(position)

	if test_move(transform, Vector2.ZERO):
		facing = old_facing
		rotation_degrees = old_rotation


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
