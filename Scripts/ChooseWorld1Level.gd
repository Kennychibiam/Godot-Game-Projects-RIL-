extends Control


onready var ChooseWorld=load("res://scenes/ChooseWorld.tscn").instance()
func _ready() -> void:
	SaveGame.loadGame()
	var levels=get_tree().get_nodes_in_group("FirstWorld")
	
	for i in levels:
		if SaveGame.load_game.has(i.name):
			var KeyLabel=i.find_node("KeyLabel")
			KeyLabel.text=str(SaveGame.load_game[i.name]["keys"])+str("/4")
			if(SaveGame.load_game[i.name]["treasure"]<2):
				var Star3=i.find_node("Star3")
				Star3.visible=false
			if(SaveGame.load_game[i.name]["keys"]<4):
				var Star2=i.find_node("Star2")
				Star2.visible=false
		else:
			var Star1=i.find_node("Star1")
			Star1.visible=false
			var Star2=i.find_node("Star2")
			Star2.visible=false
			var Star3=i.find_node("Star3")
			Star3.visible=false



func _on_BackButton_button_down() -> void:
	get_tree().get_current_scene().add_child(ChooseWorld)
	queue_free()

	
func _notification(what: int) -> void:
	if what==MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().change_scene("res://scenes/ChooseWorld.tscn")

func _on_Level1_button_down() -> void:
	get_tree().change_scene("res://scenes/Level1.tscn")

func _on_Level2_button_down() -> void:
	get_tree().change_scene("res://scenes/Level2.tscn")


func _on_Level3_button_down() -> void:
	get_tree().change_scene("res://scenes/Level3.tscn")


func _on_Level4_button_down() -> void:
	get_tree().change_scene("res://scenes/Level4.tscn")
