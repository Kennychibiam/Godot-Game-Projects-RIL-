extends Control


onready var choose_world_level=load("res://scenes/ChooseWorld1Level.tscn").instance()
func _on_World1_button_down() -> void:
	get_tree().get_current_scene().add_child(choose_world_level)
	queue_free()


func _on_BackButton_button_down() -> void:
	get_tree().change_scene("res://scenes/HomeScreen.tscn")

func _notification(what: int) -> void:
	if what==MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().change_scene("res://scenes/HomeScreen.tscn")
