extends Camera2D

@onready var player = get_node("/root/scene/player")
@onready var ground_level = 0
@onready var prop = get_node("/root/scene/prop_gen")
@onready var tilemap = get_parent().get_node("/root/scene/TileMap2")

# Camera shake parameters
const SHAKE_DURATION = 0.1
const SHAKE_AMOUNT = 1.0

# Internal variables
var shake_timer = 0.0
var original_position = Vector2()

func _ready():
	original_position = global_position

func shake():
	shake_timer = SHAKE_DURATION
	original_position = global_position

func _process(delta):
	update_camera_position()
	handle_camera_shake(delta)

func update_camera_position():
	if player.position.y > ground_level and player.player_state != 420:
		ground_level = player.position.y
		global_position.y = ground_level
		original_position = global_position
		prop.generate(tilemap.local_to_map(global_position).y + 20)
		print(ground_level)

func handle_camera_shake(delta):
	if shake_timer > 0:
		shake_timer -= delta
		var shake_offset = Vector2(randf_range(-SHAKE_AMOUNT, SHAKE_AMOUNT), randf_range(-SHAKE_AMOUNT, SHAKE_AMOUNT))
		position = original_position + shake_offset
	else:
		position = original_position

func set_camera():
	ground_level = 0
	global_position.y = 5
	original_position = global_position
