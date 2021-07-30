extends CanvasLayer



func _on_Home_pressed() -> void:
	get_tree().change_scene("res://scenes/HomeScreen.tscn")
	get_tree().paused=false



func _on_Restart_pressed() -> void:
	queue_free()
	get_tree().reload_current_scene()
	get_tree().paused=false
