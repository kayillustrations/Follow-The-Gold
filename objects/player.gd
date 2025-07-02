extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


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
