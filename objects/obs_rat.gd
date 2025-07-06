extends ObstacleObject

@onready var path_2d: Path2D = $Path2D
@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D

func _physics_process(delta: float) -> void:
	if GameManager.isPaused:
		return
	position.y += GameManager.b_movement * delta
	path_follow_2d.progress_ratio += .005
	#position += path_follow_2d.position
