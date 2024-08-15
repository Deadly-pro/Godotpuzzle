extends Node2D

@onready var tiles = get_parent().get_node("/root/scene/TileMap2")
@export var noise_height_texture: NoiseTexture2D
var width = 6
var last_level = 0

func _ready():
	for i in range(20):
		generate(i)

func generate(y = last_level):
	var noise = noise_height_texture.noise
	for x in range(width):
		var noise_value: float = noise.get_noise_2d(x, y)
		var position = Vector2i(x - width / 2, y)

		if noise_value > 0.333:
			tiles.set_cell(2, position, 0, Vector2i(0, 1))
		elif noise_value > 0.166:
			tiles.set_cell(2, position, 7, Vector2i(2, 1))
		elif noise_value > 0.0:
			tiles.set_cell(2, position, 3, Vector2i(4, 1))
		elif noise_value < -0.333:
			tiles.set_cell(2, position, 4, Vector2i(6, 2))
		elif noise_value < -0.166:
			tiles.set_cell(1, position, 5, Vector2i(6, 1))
		else:
			tiles.set_cell(2, position, 6, Vector2i(5, 1))

	last_level += 1

func _process(delta):
	pass

