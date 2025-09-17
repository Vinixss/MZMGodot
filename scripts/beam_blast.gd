extends CharacterBody2D

@onready var sprite = $Sprite2D
var dir: float

func _physics_process(delta: float) -> void:
	if dir > 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	velocity.x = dir * 2000
	move_and_slide()

func _on_body_entered(body: Node) -> void:
	pass # Replace with function body.
