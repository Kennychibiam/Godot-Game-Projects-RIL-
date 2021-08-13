extends Area2D


export var playStatic=true


func _ready() -> void:
	if playStatic:
		$AnimatedSprite.play("static spike")
	else:
		$AnimatedSprite.play("dynamic spike")


