extends CanvasLayer



func _on_Kill_Zone_2D_body_entered(body: Node) -> void:
	
	if body.name=="Player":
		print("player entered kill zone")
		body.queue_free()
		get_tree().reload_current_scene()
	elif body.name=="Skeleton":
		print("enemy entered kill zone")
		body.queue_free()
