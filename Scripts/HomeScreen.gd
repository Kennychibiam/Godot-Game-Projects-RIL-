extends Node2D

onready var skeleton=load("res://scenes/HomeScreen_Skeleton.tscn")
var isLeft=true
func _physics_process(delta: float) -> void:
	if(!$AudioStreamPlayer2D.playing):
		$AudioStreamPlayer2D.play()
	if GlobalScene.CAN_SPAWN_SKELETON:
		GlobalScene.CAN_SPAWN_SKELETON=false
		$TimerToSpawn.start()
		
  
 


func _on_TimerToSpawn_timeout() -> void:
		var new_skeleton=skeleton.instance()
		if isLeft:
			isLeft=false
			new_skeleton.position=$LeftPositionSpawn.global_position
			add_child(new_skeleton)
		elif(!isLeft):
			isLeft=true
			new_skeleton.position=$RightPositionSpawn.global_position
			add_child(new_skeleton)
