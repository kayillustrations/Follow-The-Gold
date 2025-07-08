extends ObstacleObject

func _ready() -> void:
	$Caw.play()

func _physics_process(delta: float) -> void:
	$Timer.paused = GameManager.isPaused
	
	if GameManager.isPaused:
		return
	position.y += GameManager.b_movement * delta * 4


func _on_timer_timeout() -> void:
	$Wings.play()
	$Timer.start(randf_range(.75,1.25))
	pass # Replace with function body.
