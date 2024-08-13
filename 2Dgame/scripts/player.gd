extends CharacterBody2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var keylb=$keys
var can_move=true
var inventory={"key":0,"coin":0}
var invsprdat={"heart":0,"power":1,"key":7}
const SPEED = 300.0
const JUMP_VELOCITY = -300.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _physics_process(delta):
	var directiony = Input.get_axis("forward", "downward")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_floor():
		if direction>0:
			animated_sprite.flip_h=false
		elif direction<0:
			animated_sprite.flip_h=true		
			
	if is_on_floor():
		if velocity.x>0:
			animated_sprite.play("run")
		elif velocity.x<0:
			animated_sprite.play("run")
		elif velocity.x==0:
			animated_sprite.play("idle")
	
	if direction && can_move:
		velocity.x = direction * SPEED 
	elif can_move:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if directiony && can_move:
		velocity.y = directiony * SPEED 
	elif can_move:
		velocity.y = move_toward(velocity.y, 0, SPEED) 
	move_and_slide()
	keylb.text=str(inventory["key"])

func _picked(item):
	match(item):
		"key": inventory["key"]+=1
		"coin":inventory["coin"]+=1
