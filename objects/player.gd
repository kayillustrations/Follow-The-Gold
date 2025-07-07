extends CharacterBody2D

@onready var boost: Timer = $Boost
@onready var cooldown: Timer = $Cooldown

@onready var health_comp: HealthComp = $HealthComp
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var screen_dimensions = Vector2(get_viewport().size)
var player_position_uv : Vector2
var player_starting_position : Vector2

const JUMP_VELOCITY = -400.0

var direction_x: float = 0.0
var direction_y: float = 0.0

var canMove: bool = true
var canBoost: bool = true

var isSlowed: bool = false
var isBoosted:bool = false

func _ready() -> void:
	GameManager.player = self
	player_starting_position = position
	SignalBus.isStunned.connect(edit_canMove)
	SignalBus.isSlowed.connect(edit_isSlowed)

func _process(delta) -> void:
	if GameManager.isPaused:
		return
	
	if Input.is_action_just_pressed("up"):
		if direction_y != 1:
			direction_y += 1
	if Input.is_action_just_pressed("down"):
		if direction_y != -1:
			direction_y -= 1
	if Input.is_action_just_pressed("right"):
		if direction_x != 1:
			direction_x += .5
	if Input.is_action_just_pressed("left"):
		if direction_x != -1:
			direction_x -= .5
	if Input.is_action_just_pressed("Boost"):
		if canBoost && velocity != Vector2(0,0):
			Boost(true)
			cooldown.start(1)

func _physics_process(delta: float) -> void:
	if GameManager.isPaused:
		return
	AxisMovement()
	pass

func ResetPlayer():
	direction_x = 0
	direction_y = 0
	position = player_starting_position
	velocity = Vector2.ZERO

func AxisMovement():
	if direction_x == 0:
		velocity.x = move_toward(velocity.x, 0, GameManager.player_speed)
	elif abs(direction_x) < 1: #diagonal
		velocity.x = direction_x * GameManager.player_speed
	else: #right/left
		velocity.x = direction_x * GameManager.player_speed
	
	if direction_y == 0:
		velocity.y = move_toward(velocity.y, 0, GameManager.player_speed)
	elif direction_y > 0: #back
		velocity.y = direction_y * GameManager.b_movement
	else: #forward
		velocity.y = direction_y * -GameManager.player_speed/2
	
	if !canMove: velocity.y = GameManager.b_movement
	
	if isSlowed: 
		velocity.y = GameManager.b_movement/2
	elif isBoosted:
		velocity *=2
	else: Boost(false)
	
	move_and_slide()

func Boost(activated:bool):
	var tween:= create_tween()
	if activated:
		canBoost = false
		boost.start(.5)
		tween.tween_property(self,"velocity",velocity*2,.1)
		isBoosted = true
	else:
		isBoosted = false
		tween.tween_property(self,"velocity",Vector2(0,0),.25)

func Movement():
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction_x and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x_y := Input.get_axis("ui_up","ui_down")
	var direction_x_x := Input.get_axis("ui_left", "ui_right")
	
	if !canMove: 
		velocity.y += GameManager.b_movement
		direction_x_x = 0
	
	velocity = Vector2(direction_x_x,direction_x_y) * GameManager.player_speed/1.5
	
	if !direction_x_x && !direction_x_y:
		velocity.x = move_toward(velocity.x, 0, GameManager.player_speed)
		velocity.y = move_toward(velocity.y, 0, GameManager.player_speed)
	elif direction_x_x && direction_x_y:
		velocity.y += GameManager.b_movement/4
	else:
		velocity = Vector2(direction_x_x,direction_x_y) * GameManager.player_speed
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

func _on_boost_timeout() -> void:
	isBoosted = false
	pass # Replace with function body.

func _on_cooldown_timeout() -> void:
	canBoost = true
	pass # Replace with function body.
