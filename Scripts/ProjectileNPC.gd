extends KinematicBody2D



var projectile=preload("res://scenes/ParabolicProjectile.tscn")


func _ready() -> void:
	pass # Replace with function body.




func _on_Timer_timeout() -> void:
	launch()

func launch():
	var arcHeight=GlobalScene.PLAYER_POSITION.y-$Position2D.global_position.y-25

	arcHeight=min(arcHeight,-25)
	var newProjectile=projectile.instance()
	newProjectile.global_position=$Position2D.global_position
	
	newProjectile.arcHeight=arcHeight
	newProjectile.targetPosition=GlobalScene.PLAYER_POSITION
	newProjectile.canCalculateProjectile=true
	get_tree().current_scene.add_child(newProjectile)
	
	
