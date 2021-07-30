extends KinematicBody2D


var velocity=Vector2(50,0.0)
var canSeePlayer=false
var canRun=true
var isCollidingWithPlayer=false
var speed=50.0
const MAX_SPEED=80
var player_life=3
var isAttacking=false
var isActionAllowed=true  #used to implement hit reaction
var PLAYER
var canDie=true



func _ready() -> void:
	PLAYER=load("res://scenes/Player_Knight.tscn").instance()
	$SwordDetectArea2D/CollisionShape2D.disabled=true
	set_physics_process(false)



func _physics_process(delta: float) -> void:
	if(isActionAllowed):
		collide_attack()
		detect_floor_flip()
		detect_wall_flip()
		flip()
		if !canSeePlayer:
		 $AnimatedSprite.play("walk")
		if !canRun:
		 velocity.x=0
		
		if!is_on_floor():
			velocity.y+=50
		else:
			velocity.y=0
		
	move_and_slide(velocity,Vector2.UP)
	
	


func collide_attack():
	if $DetectPlayerRayCast2D.is_colliding():
		isAttacking=true
		isCollidingWithPlayer=true
		if canRun:
			$AnimatedSprite.play("run")
		#print(position.x-GlobalScene.PLAYER_POSITION_X)
		canSeePlayer=true
		if($AnimatedSprite.flip_h):
			if(position.x-GlobalScene.PLAYER_POSITION_X<60):
			 canRun=false
			 $AnimatedSprite.play("attack")
			 $SwordDetectArea2D/CollisionShape2D.disabled=false
			else:canRun=true
		elif(!$AnimatedSprite.flip_h):
			if(position.x-GlobalScene.PLAYER_POSITION_X>-25):
				canRun=false
				$AnimatedSprite.play("attack")
				$SwordDetectArea2D/CollisionShape2D.disabled=false
			else:canRun=true
		
		if $AnimatedSprite.flip_h:
			velocity.x=-MAX_SPEED
		else:
			velocity.x=MAX_SPEED
	else:
		$SwordDetectArea2D/CollisionShape2D.disabled=true
		canSeePlayer=false
		isAttacking=false
		isCollidingWithPlayer=false
		canRun=true
		if $AnimatedSprite.flip_h==true:
			velocity.x=-speed
		else:
			velocity.x=speed
	
func flip()->void:
	if(!$AnimatedSprite.flip_h):
		$CollisionShape2D.position=Vector2(-10,12)
		$DetectPlayerRayCast2D.rotation_degrees=-90.0
		$SwordDetectArea2D/CollisionShape2D.position=Vector2(-96,-24)
		$Hit_React_Area2D/CollisionShape2D.position=Vector2(-16,6)
		$EnemyHealthBar.rect_position=Vector2(-512,-392)
		
	elif($AnimatedSprite.flip_h):
		$CollisionShape2D.position=Vector2(10,12)
		$DetectPlayerRayCast2D.rotation_degrees=90
		$SwordDetectArea2D/CollisionShape2D.position=Vector2(-104,-24)
		$Hit_React_Area2D/CollisionShape2D.position=Vector2(16,6)
		$EnemyHealthBar.rect_position=Vector2(-486,-392)
	
	
func detect_floor_flip()->void:
	if(!$FlipRightPositionRayCast2D.is_colliding() and !isAttacking):
		#print("time to flip to right")
		$AnimatedSprite.set_flip_h(false)
		velocity.x=speed
	
	if(!$FlipLeftPositionRayCast2D.is_colliding() and !isAttacking):
		#print("time to flip to left")
		$AnimatedSprite.set_flip_h(true)
		
		velocity.x=-speed
	
func detect_wall_flip()->void:
	if($DetectWallLeftRayCast2D.is_colliding() and !isAttacking):
		$AnimatedSprite.set_flip_h(false)
		
		velocity.x=speed
	
	if($DetectWallRightRayCast2D.is_colliding() and !isAttacking):
		$AnimatedSprite.set_flip_h(true)
		velocity.x=-speed

func _on_AnimatedSprite_animation_finished() -> void:
	if($AnimatedSprite.animation=="hit"):
		isActionAllowed=true
	if($AnimatedSprite.animation=="attack"):
		$SwordDetectArea2D/CollisionShape2D.disabled=true


func _on_Hit_React_Area2D_area_entered(area: Area2D) -> void:
	isActionAllowed=false
	if(canDie):
		if(GlobalScene.IS_PLAYER_FLIPPED):
			velocity.x=-50
		else:
			velocity.x=50
		$AnimatedSprite.play("hit")

