extends Node2D





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	yield(get_tree().create_timer(3),"timeout")
	$Node2D/AnimationPlayerPlatform1.play("MovingPlatform")
	


