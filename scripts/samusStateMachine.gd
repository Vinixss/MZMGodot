extends CharacterBody2D

enum States_list {STAND_FRONT, STAND_LEFT, STAND_RIGHT, RUN_LEFT, RUN_RIGHT, TURN_LEFT, TURN_RIGHT}
var cur_state: States_list = States_list.STAND_FRONT

const SPEED = 124.8
const JUMP_VELOCITY = -340.0589

@onready var beam_scene: PackedScene = preload("res://scenes/beam_blast.tscn")

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
		# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y = 0;
	
	if cur_state == States_list.STAND_FRONT:
		if direction > 0:
			set_state(States_list.STAND_RIGHT)
		elif direction < 0:
			set_state(States_list.STAND_LEFT)
	#Left states
	elif cur_state in [States_list.STAND_LEFT, States_list.RUN_LEFT] and Input.get_axis("ui_left", "ui_right") < 0:
		velocity.x = direction * SPEED
		set_state(States_list.RUN_LEFT)
	elif cur_state in [States_list.STAND_LEFT, States_list.RUN_LEFT] and Input.get_axis("ui_left", "ui_right") == 0:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		set_state(States_list.STAND_LEFT)
	elif cur_state in [States_list.STAND_LEFT, States_list.RUN_LEFT] and Input.get_axis("ui_left", "ui_right") > 0:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		set_state(States_list.TURN_RIGHT)
	
	#Right states
	elif cur_state in [States_list.STAND_RIGHT, States_list.RUN_RIGHT] and Input.get_axis("ui_left", "ui_right") < 0:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		set_state(States_list.TURN_LEFT)
	elif cur_state in [States_list.STAND_RIGHT, States_list.RUN_RIGHT] and Input.get_axis("ui_left", "ui_right") == 0:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		set_state(States_list.STAND_RIGHT)
	elif cur_state in [States_list.STAND_RIGHT, States_list.RUN_RIGHT] and Input.get_axis("ui_left", "ui_right") > 0:
		velocity.x = direction * SPEED
		set_state(States_list.RUN_RIGHT)
	
	
	if Input.is_action_just_pressed("ui_up") && not cur_state in [States_list.STAND_FRONT, States_list.TURN_LEFT, States_list.TURN_RIGHT]:
		shoot_beam()
	
	move_and_slide()

func _on_animated_sprite_2d_animation_finished() -> void:
	if cur_state == States_list.TURN_LEFT:
		if Input.get_axis("ui_left", "ui_right") < 0:
			set_state(States_list.RUN_LEFT)
		else:
			set_state(States_list.STAND_LEFT)
	elif cur_state == States_list.TURN_RIGHT:
		if Input.get_axis("ui_left", "ui_right") > 0:
			set_state(States_list.RUN_RIGHT)
		else:
			set_state(States_list.STAND_RIGHT)

func shoot_beam() -> void:
	var beam_instance = beam_scene.instantiate()
	get_tree().root.add_child(beam_instance)
	beam_instance.global_position.y = global_position.y - 7
	
	if cur_state in [States_list.STAND_RIGHT, States_list.RUN_RIGHT]:
		beam_instance.global_position.x = global_position.x + 13
		beam_instance.dir = 1.0
		print("Shot right")
	elif cur_state in [States_list.STAND_LEFT, States_list.RUN_LEFT]:
		beam_instance.global_position.x = global_position.x - 13
		beam_instance.dir = -1.0
		print("Shot left")

func set_state(new_state: int) -> void:
	cur_state = new_state
	
	if new_state == States_list.RUN_LEFT:
		animated_sprite.play("run_left")
	elif new_state == States_list.RUN_RIGHT:
		animated_sprite.play("run_right")
	elif new_state == States_list.STAND_LEFT:
		animated_sprite.play("stand_left")
	elif new_state == States_list.STAND_RIGHT:
		animated_sprite.play("stand_right")
	elif new_state == States_list.TURN_LEFT:
		animated_sprite.play_backwards("flip")
	elif new_state == States_list.TURN_RIGHT:
		animated_sprite.play("flip")
