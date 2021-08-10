extends Control


onready var choose_world=load("res://scenes/ChooseWorld.tscn").instance()
func _on_Start_pressed() -> void:

	get_tree().get_current_scene().add_child(choose_world)
	queue_free()
 # Replace with function body.


	
