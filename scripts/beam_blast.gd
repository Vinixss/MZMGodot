extends Area2D

var dir: float
@onready var sprite = $Sprite2D

func _physics_process(delta: float) -> void:
	translate(Vector2(750, 0) * delta * dir)

func _on_body_entered(body) -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()
