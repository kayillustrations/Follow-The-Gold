extends ObstacleObject

@onready var path_2d: Path2D = $Path2D
@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D

func _ready() -> void:
	$Squeak.play()


func _physics_process(delta: float) -> void:
	$WalkTimer.paused = GameManager.isPaused
	$SqueakTimer.paused = GameManager.isPaused
	
	if GameManager.isPaused:
		return
	position.y += GameManager.b_movement * delta
	path_follow_2d.progress_ratio += .005
	#position += path_follow_2d.position

func _on_squeak_timer_timeout() -> void:
	$Squeak.play()
	pass # Replace with function body.

func _on_walk_timer_timeout() -> void:
	$Walking.play()
	$WalkTimer.start(randf_range(.05,.1))
	pass # Replace with function body.
