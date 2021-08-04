extends Area2D


func _on_Key_body_entered(body: Node) -> void:
	GlobalScene.NUM_KEYS+=1
	queue_free()
