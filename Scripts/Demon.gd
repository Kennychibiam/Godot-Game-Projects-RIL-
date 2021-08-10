extends KinematicBody2D

var canStopMovement=false
var canAttack=true
var isAttacking=false
var canSeePlayer=false
var velocity=Vector2(0,0)
var allowProcess=true
export var canMoveToPlayer=false
var canDie=true
onready var Key=load("res://scenes/Key.tscn").instance()


func _ready() -> void:
	$BossSkeletonHealthBar/BossSkeletonEnemyHealthBar.visible=false

func _physics_process(delta: float) -> void:
	followPlayerDirection()
	detectPlayer()
	if allowProcess:
		if(canSeePlayer or canMoveToPlayer and !canStopMovement):
			moveToPlayer()
			
		else:
			velocity.x=0
			velocity.y=0
			$AnimatedSprite/FireBreath.play("default")
			$AnimatedSprite.play("idle")
			canAttack=true
			isAttacking=false

			$FireBreathArea2D/FireBreathCollisionShape2D.disabled=true
		if canStopMovement:
			stopMovement()

		
		move_and_slide(velocity,Vector2.UP)
	die()
	
	
func attack():
	if(canSeePlayer):
		if($AnimatedSprite.animation!="attack"):
			$AnimatedSprite.play("attack")

func stopMovement():
	if(canStopMovement):
		velocity.x=0
		velocity.y=0


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

func moveToPlayer():
	if($AnimatedSprite.flip_h):
		velocity.x=170
	else:
		velocity.x=-170
	if canMoveToPlayer:
		velocity=position.direction_to(GlobalScene.PLAYER_POSITION)*170


	


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
		if(isAttacking):
			isAttacking=false
			$AnimatedSprite.play("continuous_attack")



func _on_TimerToModulate_timeout() -> void:
	$AnimatedSprite.self_modulate="#ffffff"


func _on_StopMovement_body_entered(body: Node) -> void:
	if "Player" in body.name:
		canStopMovement=true
		if(canAttack):
			canAttack=false
			isAttacking=true
			attack()


func _on_StopMovement_body_exited(body: Node) -> void:
	if "Player" in body.name:
		canStopMovement=false
