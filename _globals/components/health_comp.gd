extends Area2D
class_name HealthComp

@export var buffer_damage: float = 1

@onready var sprite_2d: AnimatedSprite2D = get_parent().find_child("AnimatedSprite2D")
@onready var buffer_timer: Timer = $Buffer

var damaged_color:= Color.INDIAN_RED
var isAffected: bool = false

func ChangeHealth(damage:int):
	GameManager.current_health -= damage
	if GameManager.current_health <= 0:
		GameManager.current_health = 0
		SignalBus.dead.emit()
		sprite_2d.modulate = Color.DIM_GRAY
	else: 
		SignalBus.isDamaged.emit(false)

func CheckForObstacle():
	if GameManager.current_health <= 0:
		return
	var obstacles:Array= get_overlapping_areas()
	if !obstacles.is_empty():
		obstacles[0]._on_area_entered(self)

func ApplyEffect(effect):
	var effect_timer:= Timer.new()
	add_child(effect_timer)
	set_deferred("monitorable",false)
	SignalBus.isAffected.emit(true)
	buffer_timer.start(buffer_damage)
	match effect:
		SignalBus.Effects.DAMAGE:
			sprite_color(false,damaged_color)
			$"..".particles_blood.emitting = true
			$"..".particles_heart.emitting = true
			$"../Audio_damage".play()
			SignalBus.isDamaged.emit(true)
			ChangeHealth(1)
		SignalBus.Effects.SLOWNESS:
			sprite_color(false,Color.CADET_BLUE)
			$"../Audio_slow".play()
			Slowness(effect_timer)
		SignalBus.Effects.DISORIENT:
			sprite_color(false,Color.PINK)
			$"../Audio_disorient".play()
			Disorient(effect_timer)
		SignalBus.Effects.STUN:
			Stun(effect_timer)
		SignalBus.Effects.BLINDED:
			sprite_color(false,Color.GRAY)
			$"../Audio_vision".play()
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
	else: tween.tween_property(sprite_2d,"modulate",color,.25)
	
	await tween.finished
	
	if buffer_timer.is_stopped():
		sprite_2d.modulate = Color.WHITE
		SignalBus.isDamaged.emit(false)
	else:
		sprite_color(!isColored,color)

func Slowness(timer:Timer):
	SignalBus.isSlowed.emit(true)
	$"..".particles_damp.emitting = true
	timer.start(1)
	
	await timer.timeout
	SignalBus.isSlowed.emit(false)
	SignalBus.isAffected.emit(false)
	$"..".particles_damp.emitting = false
	GameManager.player_speed = GameManager.max_current_speed
	timer.queue_free()

func Disorient(timer:Timer):
	SignalBus.isDisoriented.emit(true)
	$"..".particles_dizzy.emitting = true
	timer.start(1.5)
	
	await timer.timeout
	$"..".particles_dizzy.emitting = false
	SignalBus.isDisoriented.emit(false)
	SignalBus.isAffected.emit(false)
	timer.queue_free()

func Stun(timer:Timer):
	SignalBus.isStunned.emit(true)
	timer.start(.5)
	
	await timer.timeout
	SignalBus.isAffected.emit(false)
	SignalBus.isStunned.emit(false)
	timer.queue_free()

func Blind (timer:Timer):
	SignalBus.isBlinded.emit(true)
	timer.start(1.5)
	
	await timer.timeout
	SignalBus.isAffected.emit(false)
	SignalBus.isBlinded.emit(false)
	timer.queue_free()
