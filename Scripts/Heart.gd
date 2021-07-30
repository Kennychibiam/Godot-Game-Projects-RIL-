extends Area2D




func _on_Heart_body_entered(body: Node) -> void:
	$HealthAudioStreamPlayer2D.play()
	$TimerToDestroy.start()




func _on_TimerToDestroy_timeout() -> void:
	queue_free()
