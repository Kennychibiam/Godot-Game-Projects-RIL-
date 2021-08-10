extends Area2D



onready var levelcomplete=load("res://scenes/LevelComplete.tscn").instance()


func _on_Portal_body_entered(body: Node) -> void:
	$AudioStreamPlayer2D.play()
	GlobalScene.LEVEL_COMPLETE=true
	get_tree().get_current_scene().add_child(levelcomplete)




