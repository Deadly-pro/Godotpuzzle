extends Node2D

@onready var tiles = get_parent().get_node("/root/scene/TileMap2")
@export  var noise_height_texture : NoiseTexture2D
var source_id = 0
var noise : Noise
var width = 6
var last_level = 0
func _ready():
	noise = noise_height_texture.noise
	for i in range(20):
		generate(i)
func generate(y=last_level):
	for x in range(width):
		var noise_value: float = noise.get_noise_2d(x,y)
		if noise_value > 0.0:
			if noise_value> 0.166:
				tiles.set_cell(2,Vector2(x-3,y),0,Vector2i(0,1))
			elif noise_value > 3.33:
				tiles.set_cell(2,Vector2i(x-3,y),7,Vector2i(2,1))
			else:
				tiles.set_cell(2,Vector2i(x-3,y),3,Vector2i(4,1))
		else:
			if noise_value< -0.166:
				tiles.set_cell(1,Vector2i(x-3,y),5,Vector2i(6,1))
			elif noise_value < -3.33:
				tiles.set_cell(2,Vector2i(x-3,y),4,Vector2i(6,2))
			else:
				tiles.set_cell(2,Vector2i(x-3,y),6,Vector2i(5,1))
		last_level += 1
func _process(delta):
	pass
