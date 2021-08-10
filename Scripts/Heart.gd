extends Area2D


var canCollect=true

func _on_Heart_body_entered(body: Node) -> void:
	if(canCollect):
		$HealthAudioStreamPlayer2D.play()
		canCollect=false
		$Sprite.visible=false
		$CollisionShape2D.disabled=true
		$TimerToDestroy.start()




func _on_TimerToDestroy_timeout() -> void:
	queue_free()
