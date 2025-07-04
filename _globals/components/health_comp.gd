extends Area2D
class_name HealthComp

signal dead

@export var buffer_damage: float = 1

@onready var sprite_2d: Sprite2D = get_parent().find_child("Sprite2D")
@onready var buffer_timer: Timer = $Buffer

var damaged_color:= Color.INDIAN_RED

func ChangeHealth(damage:int):
	GameManager.current_health -= damage
	if GameManager.current_health <= 0:
		GameManager.current_health = 0
		dead.emit()
		sprite_2d.modulate = Color.DIM_GRAY
	else: 
		SignalBus.isDamaged.emit(false)

func CheckForObstacle():
	var obstacles:Array= get_overlapping_areas()
	if !obstacles.is_empty():
		obstacles[0]._on_area_entered(self)

func ApplyEffect(effect):
	var effect_timer:= Timer.new()
	add_child(effect_timer)
	set_deferred("monitorable",false)
	buffer_timer.start(buffer_damage)
	match effect:
		SignalBus.Effects.DAMAGE:
			sprite_color(false,damaged_color)
			ChangeHealth(1)
		SignalBus.Effects.SLOWNESS:
			sprite_color(false,Color.SKY_BLUE)
			Slowness(effect_timer)
		SignalBus.Effects.DISORIENT:
			sprite_color(false,Color.PINK)
			Disorient(effect_timer)
		SignalBus.Effects.STUN:
			sprite_color(false,Color.YELLOW)
			Stun(effect_timer)
		SignalBus.Effects.BLINDED:
			sprite_color(false,Color.GRAY)
			Blind(effect_timer)
	SignalBus.update_ui.emit()
	await buffer_timer.timeout
	set_deferred("monitorable",true)
	CheckForObstacle()
	pass

func sprite_color(isColored:bool,color:Color):
	var tween:= create_tween()
	if isColored:
		tween.tween_property(sprite_2d,"modulate",Color.WHITE,.25)
	else: tween.tween_property(sprite_2d,"modulate",damaged_color,.25)
	
	await tween.finished
	
	if buffer_timer.is_stopped():
		sprite_2d.modulate = Color.WHITE
		SignalBus.isDamaged.emit(false)
	else:
		sprite_color(!isColored,color)

func Slowness(timer:Timer):
	SignalBus.isSlowed.emit(true)
	timer.start(1)
	
	await timer.timeout
	SignalBus.isSlowed.emit(false)
	GameManager.player_speed = GameManager.max_current_speed
	timer.queue_free()

func Disorient(timer:Timer):
	SignalBus.isDisoriented.emit(true)
	timer.start(1.5)
	
	await timer.timeout
	SignalBus.isDisoriented.emit(false)
	timer.queue_free()

func Stun(timer:Timer):
	SignalBus.isStunned.emit(true)
	timer.start(.5)
	
	await timer.timeout
	SignalBus.isStunned.emit(false)
	timer.queue_free()

func Blind (timer:Timer):
	print("Blind")
	SignalBus.isBlinded.emit(true)
	timer.start(1.5)
	
	await timer.timeout
	SignalBus.isBlinded.emit(false)
	timer.queue_free()
