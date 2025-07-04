extends CharacterBody2D

@onready var health_comp: HealthComp = $HealthComp
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var screen_dimensions = Vector2(get_viewport().size)
var player_position_uv : Vector2

const JUMP_VELOCITY = -400.0

var direction: float = 0.0
var canMove: bool = true
var isSlowed: bool = false

func _ready() -> void:
	GameManager.player = self
	SignalBus.isStunned.connect(edit_canMove)
	SignalBus.isSlowed.connect(edit_isSlowed)

func _process(delta) -> void:
	if Input.is_action_just_pressed("ui_right"):
		if direction != 1:
			direction += .5
	if Input.is_action_just_pressed("ui_left"):
		if direction != -1:
			direction -= .5

func _physics_process(delta: float) -> void:
	Movement()
	pass

func AxisMovement():
	if direction == 0: #forward
		velocity.x = move_toward(velocity.x, 0, GameManager.player_speed)
	elif abs(direction) < 1:
		velocity.x = direction * GameManager.player_speed*.75
		velocity.y = GameManager.b_movement*.75
	else: #right/left
		velocity.x = direction * GameManager.player_speed
		velocity.y = GameManager.b_movement
	
	move_and_slide()

func Movement():
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_y := Input.get_axis("ui_up","ui_down")
	var direction_x := Input.get_axis("ui_left", "ui_right")
	
	if !canMove: 
		velocity.y += GameManager.b_movement
		direction_x = 0
	
	velocity = Vector2(direction_x,direction_y) * GameManager.player_speed/1.5
	
	if !direction_x && !direction_y:
		velocity.x = move_toward(velocity.x, 0, GameManager.player_speed)
		velocity.y = move_toward(velocity.y, 0, GameManager.player_speed)
	elif direction_x && direction_y:
		velocity.y += GameManager.b_movement/4
	else:
		velocity = Vector2(direction_x,direction_y) * GameManager.player_speed
		velocity.y += GameManager.b_movement/2

	if isSlowed:
		velocity.x /= 2
		velocity.y /= 2
		velocity.y += GameManager.b_movement/2
	#velocity.y += GameManager.b_movement

	move_and_slide()

func edit_canMove(b:bool): canMove = !b

func edit_isSlowed(b:bool): isSlowed = b

func _on_health_comp_dead() -> void:
	pass # Replace with function body.
