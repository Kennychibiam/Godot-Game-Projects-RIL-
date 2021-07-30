extends Node2D
var canAddPortal=true
onready var portal=load("res://scenes/Portal.tscn").instance()
onready var PAUSE_MENU=load("res://scenes/PauseMenu.tscn")






func _ready() -> void:
	GlobalScene.COINS=0
	GlobalScene.NUM_KEYS=0
	GlobalScene.SCORE=0
	GlobalScene.TREASURE_NO=0
	GlobalScene.LEVEL_COMPLETE=false

func _notification(what: int) -> void:
	if what==MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().paused=true
		get_tree().get_current_scene().add_child(PAUSE_MENU.instance())
