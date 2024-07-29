extends StaticBody2D
@onready var animator=$AnimatedSprite2D
@onready var collider=$CollisionShape2D
@export var state="off"
# Called when the node enters the scene tree for the first time.
func _ready():
	animator.animation="idle"
func _setstate(change):
	if change!=state:
		state=change
		animator.animation=state
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state=="off":
		collider.disabled=false
	elif state=="on":
		collider.disabled=true
