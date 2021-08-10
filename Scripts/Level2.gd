extends Node2D


onready var PAUSE_MENU=load("res://scenes/PauseMenu.tscn")

func _on_HiddenAreaTrigger_body_entered(body: Node) -> void:
	if("Player" in body.name):
		$HiddenAreaTrigger.queue_free()
		$HiddenArea.queue_free()
	
func _notification(what: int) -> void:
	if what==MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().paused=true
		get_tree().get_current_scene().add_child(PAUSE_MENU.instance())



func _on_PlayPlatform_body_entered(body: Node) -> void:
	pass
	#$Node2D/Platform1/AnimationPlayer.play("MovingPlatform")
