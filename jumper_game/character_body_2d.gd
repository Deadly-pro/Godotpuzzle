extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -250.0

@onready var animation = $AnimatedSprite2D
@onready var camera = get_node("/root/scene/Camera2D")
@onready var tilemap = get_parent().get_node("/root/scene/TileMap2")
@onready var sword = $Sword
@onready var collision_shape = $CollisionShape2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var swing_duration = 0.18
var swing_angle = 60
var swinging = false
var swing_timer = 0.0
var facing_right = true
var has_jumped = false
# Custom state variable to track player condition
var player_state = 0 # 0 for normal, 420 for death, 69 for win
#No one will read these right?
func _physics_process(delta):
	handle_animation()
	handle_gravity(delta)
	if player_state < 420:
		handle_movement()
		handle_sword_swing(delta)
	check_player_state()
	move_and_slide()

func handle_animation():
	var a = randf_range(0, 400)
	if 69 <= a and a < 70:
		animation.play("blink")
	elif a < 20:
		animation.stop()

func handle_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_movement():
	if is_on_floor():
		has_jumped = false
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		has_jumped = true
	var direction = Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = direction * SPEED * (1 if is_on_floor() else 0.5)
		facing_right = direction > 0
		update_sword_position()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if has_jumped and velocity.y > 250:
		remove_tile_below()
		camera.shake()

func update_sword_position():
	if facing_right:
		sword.position.x = 8
		sword.scale.x = 1
		swing_angle = 60
	else:
		sword.position.x = -8
		sword.scale.x = -1
		swing_angle = -60

func handle_sword_swing(delta):
	if Input.is_action_just_pressed("attack") and not swinging:
		swinging = true
		swing_timer = 0.0
	
	if swinging:
		swing_timer += delta
		var progress = swing_timer / swing_duration
		update_sword_rotation(progress)
		check_and_remove_tiles()

		if swing_timer >= swing_duration:
			swinging = false
			sword.rotation_degrees = 0

func update_sword_rotation(progress):
	if progress < 0.5:
		sword.rotation_degrees = lerp(0, swing_angle, progress * 2)
	else:
		sword.rotation_degrees = lerp(swing_angle, 0, (progress - 0.5) * 2)

func check_and_remove_tiles():
	var sword_extents = sword.get_node("Area2D/CollisionShape2D").shape.extents
	var tile_position = tilemap.local_to_map(global_position + Vector2((sword_extents.x + 17) * (1 if facing_right else -1), 0))
	recursive_tile_remover(tile_position.x, tile_position.y)

func check_player_state():
	print(player_state)
	if player_state >=420:
		if player_state == 420:
			velocity.y = -100
			player_state = 421
		collision_shape.disabled = true
	else:
		collision_shape.disabled = false

func recursive_tile_remover(x, y):
	var initial_tile_type = tilemap.get_cell_source_id(2, Vector2i(x, y))
	if initial_tile_type == -1 or player_state == 420:
		return
	remove_tiles(x, y, initial_tile_type)
	camera.shake()

func remove_tile_below(x = global_position.x, y = global_position.y):
	var tile_position = tilemap.local_to_map(global_position + Vector2(0, collision_shape.shape.extents.y + 10))  
	recursive_tile_remover(tile_position.x, tile_position.y)

func remove_tiles(x, y, tile_type):
	var current_position = Vector2i(x, y)
	var current_tile_type = tilemap.get_cell_source_id(2, current_position)

	if current_tile_type != tile_type or current_tile_type == -1:
		return

	tilemap.erase_cell(2, current_position)

	var directions = [Vector2i(0, -1), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(1, 0)]
	for dir in directions:
		remove_tiles(current_position.x + dir.x, current_position.y + dir.y, tile_type)

func lerp(a, b, t):
	return a + (b - a) * t
