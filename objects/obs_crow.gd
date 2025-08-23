extends ObstacleObject

var canMove = false

func _ready() -> void:
	$Caw.play()
	$"!".emitting = true
	await $MoveTimer.timeout
	canMove = true

func _physics_process(delta: float) -> void:
	if !canMove:
		return
	$Timer.paused = GameManager.isPaused
	
	if GameManager.isPaused:
		return
	position.y += GameManager.b_movement * delta * 4


func _on_timer_timeout() -> void:
	$Wings.play()
	$Timer.start(randf_range(.75,1.25))
	pass # Replace with function body.
