extends Area2D
class_name HealthComp

signal damaged
signal dead

@onready var buffer: Timer = $Buffer
@export var buffer_time: float = 1

func ChangeHealth(damage:int):
	GameManager.current_health -= damage
	if GameManager.current_health <= 0:
		GameManager.current_health = 0
		dead.emit()
	else: 
		damaged.emit()
		buffer.start(buffer_time)
	SignalBus.update_ui.emit()

func CheckForObstacle():
	var obstacles:Array= get_overlapping_areas()
	if !obstacles.is_empty():
		obstacles[0]._on_area_entered(self)

func ApplyEffect(effect):
	match effect:
		0: ChangeHealth(1)
		1:pass
		2:pass
		3:pass
	pass
