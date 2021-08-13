extends KinematicBody2D


var arcHeight=0
var gravity=150
var velocity=Vector2.ZERO
var canCalculateProjectile=false
var targetPosition=Vector2.ZERO

func _ready() -> void:
	pass 
func _physics_process(delta: float) -> void:
	if canCalculateProjectile:
		#canCalculateProjectile=false
		print(global_position)
		print(arcHeight)
		print(targetPosition)
		velocity=calculateProjectileVelocity(global_position,targetPosition,arcHeight,gravity)

		#velocity.clamped(100) 
			#print("clamped "+velocity)
	move_and_collide(velocity*delta)

func calculateProjectileVelocity(pointA,target,arcHeight,gravity):
	var velocity=Vector2()
	var displacement=target-pointA
	
	#if displacement.y>arcHeight:
		
	var timeUp=sqrt(-2*arcHeight/float(gravity))
	var timeDown=sqrt(2*(displacement.y-arcHeight)/float(gravity))
	if is_nan(timeDown):
		timeDown=0
	velocity.y=-sqrt(-2*gravity*arcHeight)
	velocity.x=displacement.x/float(timeUp+timeDown)

	return velocity



func _on_Area2D_body_entered(body: Node) -> void:
	queue_free()


func _on_Area2D_area_entered(area: Area2D) -> void:
	queue_free()
