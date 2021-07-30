extends Area2D

onready var portal=preload("res://scenes/Portal.tscn").instance()

func _on_Key_body_entered(body: Node) -> void:
	GlobalScene.NUM_KEYS+=4
	if(GlobalScene.NUM_KEYS>=4):
		portal.position=$PortalPosition.global_position
		get_tree().get_current_scene().add_child(portal)
	queue_free()
