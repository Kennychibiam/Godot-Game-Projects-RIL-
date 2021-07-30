extends Control


func _on_RIGHT_pressed() -> void:
	Input.action_press("ui_right")


func _on_LEFT_pressed() -> void:
	Input.action_press("ui_left")


func _on_RIGHT_released() -> void:
	Input.action_release("ui_right")


func _on_LEFT_released() -> void:
	Input.action_release("ui_left")

func _on_Jump_pressed() -> void:
	Input.action_press("ui_up")


func _on_Jump_released() -> void:
	Input.action_release("ui_up")


func _on_JUMP_pressed() -> void:
	Input.action_press("ui_up")


func _on_JUMP_released() -> void:
	Input.action_release("ui_up")


func _on_Attack_pressed() -> void:
	Input.action_press("ui_attack")


func _on_Attack_released() -> void:
	Input.action_release("ui_attack")


func _on_ATTACK_pressed() -> void:
	Input.action_press("ui_attack")


func _on_ATTACK_released() -> void:
	Input.action_release("ui_attack")


func _on_Dash_pressed() -> void:
	Input.action_press("ui_dash")


func _on_Dash_released() -> void:
	Input.action_release("ui_dash")


func _on_DASH_pressed() -> void:
	Input.action_press("ui_dash")


func _on_DASH_released() -> void:
	Input.action_release("ui_dash")
