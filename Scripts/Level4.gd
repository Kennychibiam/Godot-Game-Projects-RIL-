extends Node2D


onready var PAUSE_MENU=load("res://scenes/PauseMenu.tscn")


func _ready() -> void:
	GlobalScene.COINS=0
	GlobalScene.NUM_KEYS=0
	GlobalScene.SCORE=0
	GlobalScene.TREASURE_NO=0
	GlobalScene.LEVEL_COMPLETE=false
	yield(get_tree().create_timer(2),"timeout")
	$MovingPlatform/Path2D/AnimationPlayer.play("Moving Platform")
	$MovingPlatform2/Path2D/AnimationPlayer.play("Moving Platform")
func _notification(what: int) -> void:
	if what==MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().paused=true
		get_tree().get_current_scene().add_child(PAUSE_MENU.instance())





func _on_HiddenAreaTrigger_body_entered(body: Node) -> void:
	pass # Replace with function body.
