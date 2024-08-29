extends Node2D
@onready var transition = $transition
func _ready():
	transition.play("fade_out")
	await get_tree().create_timer(0.5).timeout

func _process(delta):
	pass
