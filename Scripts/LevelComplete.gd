extends Control


func _ready() -> void:
	SaveGame.saveGame(str(get_parent().name),GlobalScene.NUM_KEYS,GlobalScene.TREASURE_NO,GlobalScene.SCORE,GlobalScene.COINS,GlobalScene.LEVEL_COMPLETE)
	$LevelComplete/Control/TextureRect/VBoxContainer/VBoxContainer/HBoxContainer/Keys.text=str(" :")+str(GlobalScene.NUM_KEYS)
	$LevelComplete/Control/TextureRect/VBoxContainer/VBoxContainer/HBoxContainer2/Coins.text=str(" :")+str(GlobalScene.COINS)
	$LevelComplete/Control/TextureRect/VBoxContainer/VBoxContainer/HBoxContainer3/Treasure.text=str(" :")+str(GlobalScene.TREASURE_NO)
	if(GlobalScene.TREASURE_NO<2):
		$LevelComplete/Control/TextureRect/VBoxContainer/StarsHbox/Star3.visible=false
func _on_Home_button_down() -> void:
	get_tree().change_scene("res://scenes/HomeScreen.tscn")


func _on_Restart_button_down() -> void:
	get_tree().reload_current_scene()
