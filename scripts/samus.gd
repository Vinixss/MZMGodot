extends CharacterBody2D


const SPEED = 124.8
const JUMP_VELOCITY = -340.0589

@onready var animated_sprite = $AnimatedSprite2D

var facing_right = true
var disable_inputs = false

#This "works" but is a mess of if-else. Need state machine
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y = 0;
	# Get the input direction and handle the movement/deceleration.
	
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction < 0 and facing_right:
		animated_sprite.play_backwards("flip")
		facing_right = false
		disable_inputs = true
	
	if direction > 0 and not facing_right:
		animated_sprite.play("flip")
		facing_right = true
		disable_inputs = true
	
	if not animated_sprite.is_playing():
		disable_inputs = false
	
	if not disable_inputs:
		if direction < 0:
			animated_sprite.play("run_left")
		elif not facing_right:
			animated_sprite.play("stand_left")
	
		if direction > 0:
			animated_sprite.play("run_right")
		elif facing_right:
			animated_sprite.play("stand_right")
	
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
