extends Control


func _ready() -> void:
	SaveGame.saveGame(str(get_parent().name),GlobalScene.NUM_KEYS,GlobalScene.TREASURE_NO,GlobalScene.SCORE,GlobalScene.COINS,GlobalScene.LEVEL_COMPLETE)
	$LevelComplete/Control/TextureRect/VBoxContainer/VBoxContainer/HBoxContainer/Keys.text=str(" :")+str(GlobalScene.NUM_KEYS)
	$LevelComplete/Control/TextureRect/VBoxContainer/VBoxContainer/HBoxContainer2/Coins.text=str(" :")+str(GlobalScene.COINS)
	$LevelComplete/Control/TextureRect/VBoxContainer/VBoxContainer/HBoxContainer3/Treasure.text=str(" :")+str(GlobalScene.TREASURE_NO)
	if(GlobalScene.TREASURE_NO<2):
		$LevelComplete/Control/TextureRect/VBoxContainer/StarsHbox/Star3.visible=false
	if(GlobalScene.NUM_KEYS<4):
		$LevelComplete/Control/TextureRect/VBoxContainer/StarsHbox/Star2.visible=false
func _on_Home_button_down() -> void:
	get_tree().change_scene("res://scenes/HomeScreen.tscn")


func _on_Restart_button_down() -> void:
	get_tree().reload_current_scene()




func _on_Next_button_down() -> void:
	var position=GlobalScene.levels.find(get_parent().name)
	if(position!=-1 and position<GlobalScene.levels.size()-1):
		var level=GlobalScene.levels[position+1]
		get_tree().change_scene("res://scenes/"+str(level)+str(".tscn"))
		
