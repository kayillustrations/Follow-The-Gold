extends Area2D
class_name HealthComp

signal damaged
signal dead

@onready var buffer: Timer = $Buffer

@export var buffer_time: float = 1
@export var max_health: int = 3

var current_health:int

func _ready() -> void:
	current_health = max_health

func ChangeHealth(damage:int):
	current_health -= damage
	if current_health <= 0:
		current_health = 0
		dead.emit()
	else: 
		damaged.emit()
		buffer.start(buffer_time)
		print(current_health)

func ApplyEffect(effect):
	match effect:
		0: ChangeHealth(1)
		1:pass
		2:pass
		3:pass
	pass
