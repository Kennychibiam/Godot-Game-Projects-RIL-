extends KinematicBody2D

var isAttacking=false
var canAttack=true
var canSeePlayer=false
var velocity=Vector2(0,0)
var allowProcess=true
var canMoveToPlayer=true
var canDie=true
onready var Key=load("res://scenes/Key.tscn").instance()


func _ready() -> void:
	$BossSkeletonHealthBar/BossSkeletonEnemyHealthBar.visible=false

func _physics_process(delta: float) -> void:
	if allowProcess:
		if(!canSeePlayer):
			velocity.x=0
			$AnimatedSprite.play("idle")
			isAttacking=false
			canAttack=true
			$AnimatedSprite/FireBreath.play("default")
			$FireBreathArea2D/FireBreathCollisionShape2D.disabled=true
		else:
			moveToPlayer()
			attackPlayer()
		followPlayerDirection()
		detectPlayer()
		move_and_slide(velocity,Vector2.UP)
	die()
	

func _on_AnimatedSprite_animation_finished() -> void:
	pass
func detectPlayer():
	if ($LeftRayCast2D.is_colliding() or $RightRayCast2D2.is_colliding()):
		canSeePlayer=true


		
	else:
		canSeePlayer=false
func followPlayerDirection():

	if(position.x-GlobalScene.PLAYER_POSITION_X<-50):
		$AnimatedSprite.set_flip_h(true)
		$AnimatedSprite/FireBreath.set_flip_h(true)
		$FireBreathArea2D/FireBreathCollisionShape2D.position=Vector2(115,91.429)
		$AnimatedSprite/FireBreath.position=Vector2(74.571,51.625)
	elif(position.x-GlobalScene.PLAYER_POSITION_X>=-50):
		$AnimatedSprite.set_flip_h(false)
		$AnimatedSprite/FireBreath.position=Vector2(-76,53.714)
		$AnimatedSprite/FireBreath.set_flip_h(false)
		$FireBreathArea2D/FireBreathCollisionShape2D.position=Vector2(-15,91.429)
	
func flip():
	pass
func moveToPlayer():
	if(canMoveToPlayer):
		if($AnimatedSprite.flip_h):
			velocity.x=150
		else:
			velocity.x=-150
#		velocity=(GlobalScene.PLAYER_POSITION-position).normalized()*150
#		velocity.y-=10
#	velocity.normalized()
func attackPlayer():

	if(!$AnimatedSprite.flip_h):
			
			if(position.x-GlobalScene.PLAYER_POSITION_X<20):
				canMoveToPlayer=false
				velocity.x=0
				if(canAttack):
					canAttack=false
					$AnimatedSprite.play("attack")
			else:canMoveToPlayer=true

			
	elif($AnimatedSprite.flip_h):
		
			if(position.x-GlobalScene.PLAYER_POSITION_X>-180):
				canMoveToPlayer=false
				velocity.x=0
				if(canAttack):
					canAttack=false
					$AnimatedSprite.play("attack")
			else:canMoveToPlayer=true


func _on_AnimatedSprite_frame_changed() -> void:
	if($AnimatedSprite.animation=="attack"):
		if($AnimatedSprite.get_frame()==7):
			$AnimatedSprite/FireBreath.play("fire")

	if($AnimatedSprite.animation=="die"):
		if($AnimatedSprite.get_frame()==7):
			Key.global_position=$KeyLocation.global_position
			get_tree().get_current_scene().add_child(Key)
			queue_free()

	if($AnimatedSprite.animation=="continuous_attack"):
		if($AnimatedSprite.get_frame()==0):
			$FireBreathArea2D/FireBreathCollisionShape2D.disabled=false
		if($AnimatedSprite.get_frame()==1):
			$FireBreathArea2D/FireBreathCollisionShape2D.disabled=true

func _on_HitReactArea2D_area_entered(area: Area2D) -> void:
	if(canDie):
		$AnimatedSprite.self_modulate="#764f4f"
		$TimerToModulate.start()
		$BossSkeletonHealthBar/BossSkeletonEnemyHealthBar/ProgressBar.value-=6
		if(GlobalScene.IS_PLAYER_FLIPPED):
			velocity.x=-50
		else:
			velocity.x=50

func die():
	if($BossSkeletonHealthBar/BossSkeletonEnemyHealthBar/ProgressBar.value<=0 and canDie):
		canDie=false
		allowProcess=false
		$HitReactArea2D/HitReactCollisionShape2D.disabled=true
		$AnimatedSprite/FireBreath.play("default")
		$AnimatedSprite.play("die")


func _on_BossArea_body_entered(body: Node) -> void:
	if("Player" in body.name):
		$BossSkeletonHealthBar/BossSkeletonEnemyHealthBar.visible=true


func _on_BossArea_body_exited(body: Node) -> void:
	if("Player" in body.name):
		$BossSkeletonHealthBar/BossSkeletonEnemyHealthBar.visible=false



func _on_FireBreath_frame_changed() -> void:
	if($AnimatedSprite/FireBreath.animation=="fire"):
		if(!isAttacking):
			isAttacking=true
			$AnimatedSprite.play("continuous_attack")



func _on_TimerToModulate_timeout() -> void:
	$AnimatedSprite.self_modulate="#360bd0"
