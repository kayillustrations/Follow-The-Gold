extends CharacterBody2D

@onready var boost: Timer = $Boost
@onready var cooldown: Timer = $Cooldown

@onready var health_comp: HealthComp = $HealthComp
#@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


var player_starting_position : Vector2

#const JUMP_VELOCITY = -400.0

var walk_mod: float = .9

var direction_x: float = 0.0
var direction_y: float = 0.0

var canMove: bool = true
var canBoost: bool = true

var isSlowed: bool = false
var isBoosted:bool = false

var prev_direction: Array = [0,0]

func _ready() -> void:
	GameManager.player = self
	player_starting_position = position
	SignalBus.isStunned.connect(edit_canMove)
	SignalBus.isSlowed.connect(edit_isSlowed)
	SignalBus.isAffected.connect(PauseWalk)
	SignalBus.GamePaused.connect(PauseTimers)
	SignalBus.coinCollected.connect(CoinSFX)

func _process(delta) -> void:
	if GameManager.isPaused:
		PauseWalk(true)
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
	CheckState()
	GetAnimated()
	pass

func ResetPlayer():
	direction_x = 0
	direction_y = 0
	position = player_starting_position
	velocity = Vector2.ZERO

func CheckState():
	if health_comp.isAffected:
		return
	if direction_y > 0 && direction_x == 0:
		PauseWalk(true)
	else: 
		PauseWalk(false)
	if prev_direction == [direction_x,direction_y]:
		return true
	else: return false

func PlayAnim(anim):
	if anim == null:
		#match movement
		pass
	else: #play anim
		pass
	pass

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
	
	if isSlowed: 
		velocity.y = GameManager.b_movement/2
		walk_mod = 1/4
	elif isBoosted:
		velocity *=2
	else: Boost(false)
	
	if !canMove: 
		velocity.y = GameManager.b_movement
	
	move_and_slide()

func GetAnimated():
	if direction_x > 0:animated_sprite_2d.flip_h = true
	else: animated_sprite_2d.flip_h = false
	if direction_y > 0: animated_sprite_2d.speed_scale = 1.5
	else: animated_sprite_2d.speed_scale = 1
	
	if direction_x == 0 && direction_y > 0:
		animated_sprite_2d.animation = "idle"
	elif direction_x == 0:
		animated_sprite_2d.animation = "forward"
	elif abs(direction_x) == 1:
		animated_sprite_2d.animation = "side"
	else:
		animated_sprite_2d.animation = "angle"

func Boost(activated:bool):
	var tween:= create_tween()
	if activated:
		canBoost = false
		boost.start(.5)
		#PlayAnim(Boost)
		$move.paused = true
		$Audio_boost.play()
		tween.tween_property(self,"velocity",velocity*2,.1)
		isBoosted = true
	else:
		#PlayAnim(null)
		$move.paused = false
		isBoosted = false
		tween.tween_property(self,"velocity",Vector2(0,0),.25)
func CoinSFX():
	$Audio_coin.play()

func PauseTimers(b:bool):
	$move.paused = b
	$Cooldown.paused = b
	$Boost.paused = b
	#pause animations

func PauseWalk(b:bool):
	$move.paused = b
	pass

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

func edit_canMove(b:bool): 
	canMove = !b
	PauseWalk(b)
func edit_isSlowed(b:bool): isSlowed = b

func _on_health_comp_dead() -> void:
	pass # Replace with function body.

func _on_boost_timeout() -> void:
	isBoosted = false
	pass # Replace with function body.

func _on_cooldown_timeout() -> void:
	canBoost = true
	pass # Replace with function body.

func _on_move_timeout() -> void:
	$Audio_move.play()
	var move_timer: float
	if isSlowed:
		move_timer = .75
	if direction_y < 0 || abs(direction_x) > .5:
		move_timer = .4
	else: move_timer = .5
	$move.start(move_timer*walk_mod)
	pass # Replace with function body.
