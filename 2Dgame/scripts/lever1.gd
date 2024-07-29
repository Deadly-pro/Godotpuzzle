extends StaticBody2D
@onready var area=$Area2D
@onready var label=$Label
@onready var animator=$AnimatedSprite2D
@onready var gate=%gate
var inrange=false
# Called when the node enters the scene tree for the first time.
func _ready():
	label.global_position=self.global_position
	label.global_position.x-=label.size.x/2
	label.global_position.y -=40
	label.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if inrange && Input.is_action_just_pressed("interact"):
		print("Interact")
		if animator.animation=="off":
			print("on")
			animator.animation="on"
			gate._setstate("on")
		elif animator.animation=="on":
			print("off")
			animator.animation="off"
			gate._setstate("off")


func _on_area_2d_body_entered(body:CharacterBody2D):
	label.show()
	inrange=true


func _on_area_2d_body_exited(body):
	label.hide()
	inrange=false
