extends Area2D
var canCollide=true
func _ready() -> void:
	$Control.visible=false

func _on_Coin_body_entered(body: Node) -> void:
	if canCollide:
		canCollide=false
		$AudioStreamPlayer2D.play()
		$CollisionShape2D.set_deferred("disabled",true)
		$AnimatedSprite.play("pickup")
		$AnimationPlayer.play("Coin_Pickup")
	




func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if(anim_name=="Coin_Pickup"):
		queue_free()
