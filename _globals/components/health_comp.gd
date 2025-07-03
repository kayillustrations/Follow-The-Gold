extends Area2D
class_name HealthComp

signal damaged
signal dead

@onready var sprite_2d: Sprite2D = get_parent().find_child("Sprite2D")
@onready var buffer: Timer = $Buffer
@export var buffer_time: float = 1

var damaged_color:= Color.INDIAN_RED

func ChangeHealth(damage:int):
	GameManager.current_health -= damage
	if GameManager.current_health <= 0:
		GameManager.current_health = 0
		dead.emit()
		sprite_2d.modulate = Color.DIM_GRAY
	else: 
		damaged.emit()
		buffer.start(buffer_time)
		sprite_color(false)
	set_deferred("monitorable",false)
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

func sprite_color(isColored:bool):
	var tween:= create_tween()
	if isColored:
		tween.tween_property(sprite_2d,"modulate",Color.WHITE,.25)
	else: tween.tween_property(sprite_2d,"modulate",damaged_color,.25)
	
	await tween.finished
	
	if buffer.is_stopped():
		sprite_2d.modulate = Color.WHITE
		set_deferred("monitorable",true)
		CheckForObstacle()
	else:
		sprite_color(!isColored)
