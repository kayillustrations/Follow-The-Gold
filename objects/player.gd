extends CharacterBody2D

@onready var health_comp: HealthComp = $HealthComp
@onready var sprite_2d: Sprite2D = $Sprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var damaged_color:= Color.INDIAN_RED

func _physics_process(delta: float) -> void:

	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_y := Input.get_axis("ui_up","ui_down")
	var direction_x := Input.get_axis("ui_left", "ui_right")
	if !direction_x && !direction_y:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	elif direction_x && direction_y:
		velocity = Vector2(direction_x,direction_y) * SPEED/1.5
	else:
		velocity = Vector2(direction_x,direction_y) * SPEED

	move_and_slide()

func sprite_color(isColored:bool):
	var tween:= create_tween()
	if isColored:
		tween.tween_property(sprite_2d,"modulate",Color.WHITE,.25)
	else: tween.tween_property(sprite_2d,"modulate",damaged_color,.25)
	
	await tween.finished
	
	if health_comp.buffer.is_stopped():
		sprite_2d.modulate = Color.WHITE
		health_comp.set_deferred("monitorable",true)
		health_comp.CheckForObstacle()
	else:
		sprite_color(!isColored)
	

func _on_health_comp_damaged() -> void:
	sprite_color(false)
	health_comp.set_deferred("monitorable",false)


func _on_health_comp_dead() -> void:
	pass # Replace with function body.
