extends KinematicBody2D







export var impulse=2000.0 #calculates the strength of pulse jump when stomp enemy
var velocity=Vector2.ZERO
const floor_normal=Vector2.UP   #needed when using move and slide
var speed=Vector2(350.0,1000.0)#controls speed of x and jump height 
export var gravity=100.0  #controls the gravity 
var anim_state_machine  
var animated_sprites
var isJumping=false
var isAttacking=false
var canPlayNextAttack=false
var jump_count=0
const MAX_JUMP_COUNT=2
const MAX_ATTACK_COUNT=2
var attack_count=0
var canDisplayUI=true
var allowOtherProcesses=true
var countHigh=0
var canDash=true
var canSeeEnemy=false
var canRun=true



func _ready() -> void:
	GlobalScene.LEVEL_COMPLETE=false
	if(get_parent().name=="Home"):
		canDisplayUI=false
		SaveGame.loadGame()
		if(!SaveGame.load_game.empty()):
			$CoinBar/CoinBar/HBoxContainer/Label.text=str(SaveGame.load_game["coins"])
	animated_sprites=$AnimatedSprite
	$Sword_Hit_Area/SwordCollisionShape2D.disabled=true
	if(!canDisplayUI):
		$HealthBar.queue_free()
		$KeyBar.queue_free()
	#anim_state_machine=$AnimationTree.get("parameters/playback")
	



func _physics_process(delta: float) -> void:
	
	
	GlobalScene.PLAYER_POSITION_X=position.x
	
	
	if(allowOtherProcesses):
		if(!is_on_floor()):
			velocity.y=50
		else:velocity.y=0
		ray_cast_collisions()
		if canSeeEnemy:
			stop_and_Attack()
		else:
			velocity.x=0
			$AnimatedSprite.play("idle")
		flip_character()




	
	move_and_slide(velocity,floor_normal)


func stop_and_Attack():
	if($LeftRayCast2D.is_colliding()):

		if(position.x-GlobalScene.SKELETON_POSITION.x<95):
			canRun=false
			velocity.x=0
			if(attack_count==0):
				canPlayNextAttack=false
				animated_sprites.play("attack1")
				$SwordSlash.play()
				attack_count+=1
				$TimerForAttackCombo.start()
			if(attack_count==1 and canPlayNextAttack):
				animated_sprites.play("attack2")
				$SwordSlash.play()
				attack_count=0
		else:
			canRun=true
			moveToEnemy()
	elif($RightRayCast2D.is_colliding()):
		print(position.x-GlobalScene.SKELETON_POSITION.x)
		if(position.x-GlobalScene.SKELETON_POSITION.x>-110):
			canRun=false
			velocity.x=0
			if(attack_count==0):
				canPlayNextAttack=false
				animated_sprites.play("attack1")
				$SwordSlash.play()
				attack_count+=1
				$TimerForAttackCombo.start()
			if(attack_count==1 and canPlayNextAttack):
				animated_sprites.play("attack2")
				$SwordSlash.play()
				attack_count=0
		else:
			canRun=true
			moveToEnemy()



func dash()->void:
	if(canDash):
		#direction.x=0
		canDash=false
		allowOtherProcesses=false
		$AnimatedSprite.play("dash")
		if($AnimatedSprite.flip_h):
			velocity.x=-1*10000
		else:velocity.x=10000
		$TimerForDash.start()
	
func ray_cast_collisions()->void:
	if($LeftRayCast2D.is_colliding() or $RightRayCast2D.is_colliding()):
		canSeeEnemy=true
	else:canSeeEnemy=false

func flip_character()->void:
	if $LeftRayCast2D.is_colliding():
		GlobalScene.IS_PLAYER_FLIPPED=true
		$Sword_Hit_Area/SwordCollisionShape2D.position=Vector2(-80,-113)
		#$CollisionShape2D.position=Vector2(72,62)
	elif $RightRayCast2D.is_colliding():
		GlobalScene.IS_PLAYER_FLIPPED=false
		$Sword_Hit_Area/SwordCollisionShape2D.position=Vector2(120,-113)
		#$CollisionShape2D.position=Vector2(-250,20)

func calculate_move_velocity(linear_Velocity:Vector2,speed:Vector2,direction:Vector2,is_jump_interrupted:bool)->Vector2:
	var new_velocity:=linear_Velocity
	new_velocity.x=speed.x*direction.x

	new_velocity.y+=50
	
	new_velocity.y=clamp(new_velocity.y,-1200,800)
	#print(new_velocity.y)
	
	if (direction.y==-1.0 and jump_count<1 and is_on_floor())  :
		animated_sprites.play("jump")
		jump_count+=1
		new_velocity.y=-speed.y  #how far up player should go when jump is pressed
	if !is_on_floor() and (Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("ui_up")) and jump_count<MAX_JUMP_COUNT:
		 animated_sprites.play("jump")
		 jump_count+=1
		 new_velocity.y=-speed.y

	#if is_jump_interrupted:
	#	new_velocity.y=0.0
	
	

	return new_velocity



func _on_AnimatedSprite_animation_finished() -> void:
	
	if(animated_sprites.animation=="attack1"):
		canPlayNextAttack=true
		
	if(animated_sprites.animation=="hit"):
		allowOtherProcesses=true
	


func _on_Sword_Hit_Area_body_entered(body: Node) -> void:
	$AudioStreamPlayer2D.play()


func _on_TimerForAttackCombo_timeout() -> void:
	canPlayNextAttack=false
	attack_count=0


func _on_AnimatedSprite_frame_changed() -> void:
	if($AnimatedSprite.animation=="attack1"):
		if($AnimatedSprite.get_frame()==2):
			$Sword_Hit_Area/SwordCollisionShape2D.disabled=false
		else:$Sword_Hit_Area/SwordCollisionShape2D.disabled=true
	if($AnimatedSprite.animation=="attack2"):
		if($AnimatedSprite.get_frame()==2):
			$Sword_Hit_Area/SwordCollisionShape2D.disabled=false
		else:$Sword_Hit_Area/SwordCollisionShape2D.disabled=true

func moveToEnemy():
		if(canRun):
			$AnimatedSprite.play("run")
			if($LeftRayCast2D.is_colliding()):
				$AnimatedSprite.set_flip_h(true)
				velocity.x=-200
			elif($RightRayCast2D.is_colliding()):
				$AnimatedSprite.set_flip_h(false)
				velocity.x=200
		else:velocity.x=0

func _on_TimerForDash_timeout() -> void:
	canDash=true
	allowOtherProcesses=true
	velocity.x=0
