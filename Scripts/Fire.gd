extends Node2D

var speed=5

func _physics_process(delta: float) -> void:
	position.x+=speed

func _on_FireProjectile_area_entered(area: Area2D) -> void:
	queue_free()


func _on_FireProjectile_body_entered(body: Node) -> void:
	queue_free()
