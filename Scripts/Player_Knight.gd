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
var direction=Vector2.ZERO
var canDisplayUI=true
var allowOtherProcesses=true
var countHigh=0
var canDash=true

onready var restartHome=load("res://scenes/Restart_Home.tscn").instance()

func _ready() -> void:
	GlobalScene.LEVEL_COMPLETE=false
	if(get_parent().name=="Home"):
		canDisplayUI=false
		set_physics_process(false)
		SaveGame.loadGame()
		if(!SaveGame.load_game.empty()):
			$CoinBar/CoinBar/HBoxContainer/Label.text=str(SaveGame.load_game["coins"])
	animated_sprites=$AnimatedSprite
	$Sword_Hit_Area/SwordCollisionShape2D.disabled=true
	if(!canDisplayUI):
		$HealthBar.queue_free()
		$Direction_Buttons.queue_free()
		$KeyBar.queue_free()
	#anim_state_machine=$AnimationTree.get("parameters/playback")
	



func _physics_process(delta: float) -> void:
	#print(get_parent().name+" parent")
	GlobalScene.PLAYER_POSITION_X=position.x
	GlobalScene.PLAYER_POSITION=position
	if(GlobalScene.LEVEL_COMPLETE or GlobalScene.LEVEL_FAILED):
		$AnimatedSprite.visible=false
		set_physics_process(false)
	
	#var is_jump_interrupted =  Input.is_action_just_released("jump") and velocity.y < 0.0
	#var direction:=getDirection()
	
	
	
	
	if(allowOtherProcesses):

		getActionAttack()
		direction_input()
		flip_character()
		play_animations_states()
		die()
		ray_cast_collisions()
	velocity=calculate_move_velocity(velocity,speed,direction,false)
	
	if(Input.is_action_just_pressed("ui_dash")):
		dash()
	move_and_slide(velocity,floor_normal)


func getActionAttack():
	if(Input.is_action_just_pressed("ui_attack")or Input.is_action_just_pressed("attack")):
		isAttacking=true


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

func direction_input()->void:
	
	if(Input.is_action_just_pressed("ui_left")):
		direction.x=-1
	if(Input.is_action_just_pressed("ui_right")):
		direction.x=1
		
	if(Input.is_action_just_pressed("ui_up")) :
		direction.y=-1
	
	if(Input.is_action_just_released("ui_left")):
		direction.x=0
	if(Input.is_action_just_released("ui_right")):
		direction.x=0
		
	if(Input.is_action_just_released("ui_up")):
		direction.y=0
	
	
func dash()->void:
	if(canDash):
		$Camera2D.smoothing_enabled=true
		direction.x=0
		velocity.y=0
		canDash=false
		allowOtherProcesses=false
		$AnimatedSprite.play("dash")
		if($AnimatedSprite.flip_h):
			velocity.x=-1*10000
		else:velocity.x=10000
		$TimerForDash.start()
	
func ray_cast_collisions()->void:
	if $DoubleJumpRayCast2D.is_colliding():
		jump_count=0

		

func flip_character()->void:
	if direction.x==-1:
		animated_sprites.set_flip_h(true)
		GlobalScene.IS_PLAYER_FLIPPED=true
		$DoubleJumpRayCast2D.position=Vector2(7,-86)
		$DoubleJumpRayCast2D.rotation_degrees=90
		$Sword_Hit_Area/SwordCollisionShape2D.position=Vector2(-80,-113)
		#$CollisionShape2D.position=Vector2(72,62)
	elif direction.x==1:
		animated_sprites.set_flip_h(false)
		GlobalScene.IS_PLAYER_FLIPPED=false
		$DoubleJumpRayCast2D.position=Vector2(67,-86)
		$DoubleJumpRayCast2D.rotation_degrees=-90
		$Sword_Hit_Area/SwordCollisionShape2D.position=Vector2(120,-113)
		#$CollisionShape2D.position=Vector2(-250,20)
func play_animations_states()->void:
	if(!is_on_floor()):
		isJumping=true
		countHigh+=1
		#print("in air "+String(countHigh))
	else:
		if(countHigh>=60):
			$AnimationPlayer.play("camera_shake")
		#print("on ground "+String(countHigh))
		countHigh=0
		velocity.y=0
		jump_count=0
		isJumping=false
	
	if(!is_on_floor() and velocity.y>-1000 and !isAttacking):
		animated_sprites.play("fall")
	
	if (direction.x != 0 and !isJumping and !isAttacking):
		animated_sprites.play("run")
		#anim_state_machine.travel("move")
	elif (direction.x==0 and !isJumping and !isAttacking):
		animated_sprites.play("idle")
		#anim_state_machine.travel("idle")

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
	if(animated_sprites.animation=="attack1" or animated_sprites.animation=="attack2"):
		isAttacking=false
		velocity.x=0

	
	if(animated_sprites.animation=="attack1"):
		canPlayNextAttack=true
		
	if(animated_sprites.animation=="hit"):
		allowOtherProcesses=true
	if(animated_sprites.animation=="death"):
		$AnimatedSprite.visible=false

func die()->void:
	if($HealthBar/HEALTH/HealthBar.value<=0):
		allowOtherProcesses=false
		get_tree().get_current_scene().add_child(restartHome)
		$CollisionShape2D.disabled=true
		velocity.y=0
		$Player_React_Area2D/CollisionShape2D.disabled=true
		animated_sprites.play("death")
		



func _on_Player_React_Area2D_area_entered(area: Area2D) -> void:

	if("SwordDetect" in area.name):
		$HealthBar/HEALTH/HealthBar.value-=GlobalScene.ENEMY_SWORD_DAMAGE
	if("Heart" in area.name):
		$HealthBar/HEALTH/HealthBar.value+=20
		
	if("Coin" in area.name):
		GlobalScene.COINS+=1
		$CoinBar/CoinBar/HBoxContainer/Label.text=str(GlobalScene.COINS)
	if("FireBreath" in area.name):
		$HealthBar/HEALTH/HealthBar.value-=GlobalScene.BOSS_ENEMY_FIRE_DAMAGE
	if("Key" in area.name):
		$KeyBar/KeyBar/HBoxContainer/Label.text=str(GlobalScene.NUM_KEYS)

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
	if ($AnimatedSprite.animation=="run"):
		if($AnimatedSprite.get_frame()==0):
			$GrassStepSound.play()
			yield(get_tree().create_timer(0.2),"timeout")
			$GrassStepSound.stop()
		if($AnimatedSprite.get_frame()==4):
			$GrassStepSound.play()
			yield(get_tree().create_timer(0.2),"timeout")
			$GrassStepSound.stop()
		



func _on_TimerForDash_timeout() -> void:
	$Camera2D.smoothing_enabled=false
	canDash=true
	allowOtherProcesses=true
	velocity.x=0
