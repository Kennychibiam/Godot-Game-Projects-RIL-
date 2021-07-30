extends Node2D

func _physics_process(delta: float) -> void:
 pass


func _on_Area2D_body_entered(body: Node) -> void:
	queue_free()


func _on_Area2D_area_entered(area: Area2D) -> void:
	queue_free()
