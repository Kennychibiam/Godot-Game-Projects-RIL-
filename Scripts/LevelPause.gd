extends CanvasLayer

var PAUSE_MENU
func _ready() -> void:
	PAUSE_MENU=load("res://scenes/PauseMenu.tscn")



func _on_LevelPauseButton_pressed() -> void:
	get_tree().paused=true
	get_tree().get_current_scene().add_child(PAUSE_MENU.instance())
