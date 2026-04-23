extends CharacterBody2D

@export var type : Type
enum Type {FRUIT_ORG, FRUIT_GMO, BASKET_ORG, BASKET_GMO}
signal moved

const TILE_SIZE := 64
const MOVE_SPEED := 300.0

var target_position : Vector2
var is_moving := false

func _ready():
	target_position = position

func _process(delta):
	if is_moving:
		move_to_target(delta)
		return

	var direction := Vector2.ZERO

	if type == Type.BASKET_ORG:
		direction = get_arrow_input()
	elif type == Type.BASKET_GMO:
		direction = get_wasd_input()

	if direction != Vector2.ZERO:
		start_move(direction)
		#will need a refractor later for now a horrid solution which I hate, but Im vibing rn cuz I have crapload to do and not much time
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
	
func start_move(direction: Vector2):
	var motion = direction * TILE_SIZE

	if not test_move(transform, motion):
		target_position = position + motion
		is_moving = true
		

func move_to_target(delta):
	position = position.move_toward(target_position, MOVE_SPEED * delta)

	if position.distance_to(target_position) < 1:
		position = target_position
		is_moving = false
		if type == Type.BASKET_ORG or type == Type.BASKET_GMO:
			emit_signal("moved")
func get_type():
	return type



func _on_only_use_with_baskets_body_entered(body: Node2D) -> void:
	if type != Type.BASKET_ORG and type != Type.BASKET_GMO:
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
