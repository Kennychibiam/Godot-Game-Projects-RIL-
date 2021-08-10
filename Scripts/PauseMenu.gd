extends CanvasLayer



func _on_Home_pressed() -> void:

	get_tree().change_scene("res://scenes/HomeScreen.tscn")
	get_tree().paused=false


func _on_Resume_pressed() -> void:
	queue_free()
	get_tree().paused=false


func _on_Restart_pressed() -> void:
	GlobalScene.restart()
	queue_free()
	get_tree().reload_current_scene()
	get_tree().paused=false


func _on_Settings_pressed() -> void:
	pass # Replace with function body.


func _on_Camera_pressed() -> void:
	pass # Replace with function body.
