extends State
class_name Turn

@onready var player = $"../.."

func Enter():
	pass

func Update(delta: float):
	if player.facing_right:
		player.animated_sprite.play_backwards("flip")
	else:
		player.animated_sprite.play("flip")
	
	if not player.animated_sprite.is_playing():
		Transition.emit(self, "idle")
