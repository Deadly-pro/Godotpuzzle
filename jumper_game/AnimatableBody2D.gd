extends AnimatableBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var a = randi_range(1,5)
	$AnimatedSprite2D.play(str(a))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
