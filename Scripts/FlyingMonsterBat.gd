extends KinematicBody2D

export var canMoveToPlayer=false
var canSee=false
var movement=Vector2.ZERO
var attackSpeed=80
var isPlayerAtLeft=false
var fireProjectile=preload("res://scenes/Fire.tscn")
var canDie=true
func _ready() -> void:
	set_physics_process(false)
func _physics_process(delta: float) -> void:
	flip()
	if (canSee or canMoveToPlayer):#!canStopMovement is not needed because bat uses a ray cast for stopping movement while demon uses a collision area
		moveToPlayer()
	else:
		movement.x=0
		movement.y=0
	
	

	stopMovement()
	#stillFloat()
	die()
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
		
	if(!canSee):
		if(movement.x>0):
			$AnimatedSprite.set_flip_h(true)
		elif(movement.x<0):
			$AnimatedSprite.set_flip_h(false)
func stopMovement():
	if($StopRayCastLeft.is_colliding() or $StopRayCastRight.is_colliding()):
		movement.x=0
		movement.y=0
	
	
func moveToPlayer():
	if(isPlayerAtLeft):
		movement.x=-attackSpeed
	elif(!isPlayerAtLeft):
		movement.x=attackSpeed
	if(canMoveToPlayer):
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


func _on_HitReact_area_entered(area: Area2D) -> void:
	$EnemyHealthBar/ProgressBar.value-=GlobalScene.PLAYER_SWORD_DAMAGE
	$AnimatedSprite.self_modulate="#7a5858"
	yield(get_tree().create_timer(0.15),"timeout")
	$AnimatedSprite.self_modulate="#ffffff"
func die():
	if $EnemyHealthBar/ProgressBar.value<=0:
		$AnimatedSprite.visible=false
		$DeathAnimation.visible=true
		$DeathAnimation.play("explode")


func _on_DeathAnimation_frame_changed() -> void:
	if($DeathAnimation.animation=="explode"):
		if($DeathAnimation.frame==2):
			queue_free()
