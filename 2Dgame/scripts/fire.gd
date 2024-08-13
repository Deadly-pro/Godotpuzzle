extends Node2D
var a:int
func _ready():
	a=randi_range(1,4)
	print(a)
	match(a):
		1: $AnimatedSprite2D.play("small") 
		
		2: $AnimatedSprite2D.play("vsmall")
		
		3: pass 
	await get_tree().create_timer(10).timeout
	$AnimatedSprite2D.play("loop")

