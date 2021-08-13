extends Node2D

onready var PAUSE_MENU=load("res://scenes/PauseMenu.tscn")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalScene.COINS=0
	GlobalScene.NUM_KEYS=0
	GlobalScene.SCORE=0
	GlobalScene.TREASURE_NO=0
	GlobalScene.LEVEL_COMPLETE=false

	yield(get_tree().create_timer(2),"timeout")
	$MovingPlatform1/AnimationPlayerPlatform1.play("MovingPlatform")
	$MovingPlatform2/AnimationPlayerPlatform1.play("MovingPlatformHorizontal")




func _on_HiddenAreaTrigger_body_entered(body: Node) -> void:
	if (body.name=="Player_Knight"):
		$HiddenArea.queue_free()
		$HiddenAreaTrigger.queue_free()

func _notification(what: int) -> void:
	if what==MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().paused=true
		get_tree().get_current_scene().add_child(PAUSE_MENU.instance())
