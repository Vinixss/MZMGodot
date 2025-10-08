extends Area2D

enum States_list {CLOSED, OPEN}
enum Color_list {GREY, BLUE, RED, GREEN, ORANGE}
var cur_state: States_list = States_list.CLOSED
var cur_color: Color_list

@onready var animated_sprite = $AnimatedSprite2D
@onready var door_collision = $DoorBody/Collision




func change_state(new_state: int) -> void:
	if new_state == cur_state:
		return
	elif new_state == States_list.OPEN:
		door_collision.set_deferred("disabled", true)
	elif new_state == States_list.CLOSED:
		door_collision.set_deferred("disabled", false)




func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Beam"):
		change_state(States_list.OPEN)
