extends Area2D


func _on_Key_body_entered(body: Node) -> void:
	queue_free()
