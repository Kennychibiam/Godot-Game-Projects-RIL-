extends ParallaxLayer

func _physics_process(delta: float) -> void:
	motion_offset.x+=10*delta

