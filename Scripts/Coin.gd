extends KinematicBody2D
var canCollide=true
var canBounce=false
var velocity=Vector2(70,150)
var bounceCount=0
var yBounceMult=0.85
func _ready() -> void:
	$Control.visible=false



func _physics_process(delta: float) -> void:
	if canBounce:
		var collisionInfo=move_and_collide(velocity*delta)
		if collisionInfo:
			velocity=velocity.bounce(collisionInfo.normal)
			$TimerForBounce.start()


func _on_Coin_body_entered(body: Node) -> void:
	if canCollide:
		velocity.y=0
		velocity.x=0
		canCollide=false
		$AudioStreamPlayer2D.play()
		$Coin/CollisionShape2D.set_deferred("disabled",true)
		$Coin/AnimatedSprite.play("pickup")
		$AnimationPlayer.play("Coin_Pickup")

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if(anim_name=="Coin_Pickup"):
		queue_free()


func _on_TimerForBounce_timeout() -> void:
	velocity.y*=-yBounceMult
	velocity.x*=0.3
	yBounceMult/=1.5
	++bounceCount

