extends StaticBody2D

enum States_list {CLOSED, OPEN}
enum Color_list {GREY, BLUE, RED, GREEN, ORANGE}
var cur_state: States_list = States_list.CLOSED
var cur_color: Color_list

@onready var animated_sprite = $AnimatedSprite2D
@onready var door_collision = $Collision


func _setup(color) -> void:
	pass

func change_state(new_state: States_list) -> void:
	if new_state == cur_state:
		return
	elif new_state == States_list.OPEN:
		door_collision.disabled = true
	elif new_state == States_list.CLOSED:
		door_collision.disabled = false
