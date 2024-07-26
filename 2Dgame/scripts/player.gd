extends CharacterBody2D
@onready var animated_sprite = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


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
	
	if direction:
		velocity.x = direction * SPEED 
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if directiony:
		velocity.y = directiony * SPEED 
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
