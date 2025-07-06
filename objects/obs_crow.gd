extends ObstacleObject

func _physics_process(delta: float) -> void:
	if GameManager.isPaused:
		return
	position.y += GameManager.b_movement * delta * 3
