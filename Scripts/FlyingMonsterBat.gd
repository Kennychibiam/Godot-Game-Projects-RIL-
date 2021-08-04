extends KinematicBody2D

var canSee=false
var movement=Vector2.ZERO
var attackSpeed=80
var isPlayerAtLeft=false
var fireProjectile=preload("res://scenes/Fire.tscn")

func _ready() -> void:
	pass
func _physics_process(delta: float) -> void:
	flip()
	if (canSee):
		pass
	moveToPlayer()
	stopMovement()
	#stillFloat()
	move_and_slide(movement,Vector2.UP)

func flip():
	if($VisionRayCastLeft.is_colliding() or $VisionRayCastRight.is_colliding()):
		canSee=true
		if $VisionRayCastLeft.is_colliding():
			isPlayerAtLeft=true
			$AnimatedSprite.set_flip_h(false)
		elif $VisionRayCastRight.is_colliding():
			isPlayerAtLeft=false
			$AnimatedSprite.set_flip_h(true)
	else:
		canSee=false
		
func stopMovement():
	if($StopRayCastLeft.is_colliding() or $StopRayCastRight.is_colliding()):
		movement.x=0
	
	
func moveToPlayer():
	if(isPlayerAtLeft):
		movement.x=-attackSpeed
	elif(!isPlayerAtLeft):
		movement.x=attackSpeed
	movement=position.direction_to(GlobalScene.PLAYER_POSITION)*80

func stillFloat():
	
	if $BottomRayCast.is_colliding():
		movement.y=-50
	else:movement.y=0


func _on_TimerToFire_timeout() -> void:
	if canSee:
		var newProjectile=fireProjectile.instance()
		newProjectile.position=$FireProjectilePosition.global_position
		var sprite=newProjectile.find_node("Sprite")
	
		if(isPlayerAtLeft):
			newProjectile.speed=-5
			sprite.flip_v=true
		elif (!isPlayerAtLeft):
			newProjectile.speed=5
			sprite.flip_v=false
		get_tree().get_current_scene().add_child(newProjectile)
