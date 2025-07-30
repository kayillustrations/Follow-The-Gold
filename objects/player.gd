extends CharacterBody2D

@onready var boost: Timer = $Boost
@onready var cooldown: Timer = $Cooldown

@onready var health_comp: HealthComp = $HealthComp
#@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var particles_walk: CPUParticles2D = $"Walk part"
@onready var particles_damp: CPUParticles2D = $damp
@onready var particles_blood: CPUParticles2D = $blood
@onready var particles_dizzy: CPUParticles2D = $dizzy
@onready var particles_boost: CPUParticles2D = $"boost part"
@onready var particles_heart: CPUParticles2D = $heart
@onready var particles_coin: CPUParticles2D = $coin

var player_starting_position : Vector2

#const JUMP_VELOCITY = -400.0

var walk_mod: float = .9

var mouse_pos:Vector2
var viewport_size: Vector2
var temp_calc: Vector2
var isJustClicked: bool = false

var direction_x: float = 0.0
var direction_y: float = 0.0

var canMove: bool = true
var canBoost: bool = true

var isSlowed: bool = false
var isBoosted:bool = false

var prev_direction: Array = [0,0]
var eq_effect : AudioEffectEQ10

func _ready() -> void:
	GameManager.player = self
	player_starting_position = position
	SignalBus.isStunned.connect(edit_canMove)
	SignalBus.isSlowed.connect(edit_isSlowed)
	SignalBus.isAffected.connect(PauseWalk)
	SignalBus.GamePaused.connect(PauseTimers)
	SignalBus.coinCollected.connect(CoinSFX)
	SignalBus.dead.connect(_on_health_comp_dead)
	eq_effect = AudioServer.get_bus_effect(1,0)
	get_viewport().size_changed.connect(_on_viewport_size_changed)
	_on_viewport_size_changed()
	ResetPlayer()

func _process(delta) -> void:
	if GameManager.isPaused:
		PauseWalk(true)
		return
	
	if Input.is_action_just_pressed("Boost"):
		ActivateBoost()
	
	if GameManager.usingMouse:
		mouse_pos = get_global_mouse_position()
		temp_calc = mouse_pos - global_position #diff between clara and mouse
		MouseMovement()
		if Input.is_action_just_pressed("Click"):
			if isJustClicked && ActivateBoost():
				isJustClicked = false
				#print("boosted")
			else: 
				isJustClicked = true
				$justClicked.start(.25)
			
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
	particles_walk.emitting = false
	particles_damp.emitting = false
	particles_blood.emitting = false
	particles_dizzy.emitting = false
	particles_boost.emitting = false
	particles_heart.emitting = false
	particles_coin.emitting = false
	get_parent().get_parent().get_child(0).position = Vector2(0,0) #reset camera

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

func MouseMovement():
	var abs_calc:Vector2 = abs(temp_calc)
	var mod: Vector2 = Vector2(1,1)
	if temp_calc.x < 0:mod.x = -1
	if temp_calc.y > 0: mod.y = -1
	
	if abs_calc.x > 300 : direction_x = mod.x
	elif abs_calc.x > 100: direction_x = .5 * mod.x
	else: direction_x = 0
	
	if abs_calc.y < 100: direction_y = 0
	else: direction_y = mod.y
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
	else: 
		Boost(false)
		walk_mod = .9
	
	if !canMove: 
		velocity.y = GameManager.b_movement
	
	move_and_slide()

func GetAnimated():
	if direction_x > 0:animated_sprite_2d.flip_h = true
	else: animated_sprite_2d.flip_h = false
	if direction_y < 0: 
		animated_sprite_2d.speed_scale = 1.75
	else: 
		animated_sprite_2d.speed_scale = 1.15
	
	if direction_x == 0 && direction_y > 0:
		animated_sprite_2d.animation = "idle"
		particles_walk.emitting = false
	elif direction_x == 0:
		animated_sprite_2d.animation = "forward"
		particles_walk.emitting = true
	elif abs(direction_x) == 1:
		animated_sprite_2d.animation = "side"
		particles_walk.emitting = true
	else:
		animated_sprite_2d.animation = "angle"
		particles_walk.emitting = true

func ActivateBoost():
	if canBoost && velocity != Vector2(0,0):
		Boost(true)
		return true
	return false

func Boost(activated:bool):
	var tween:= create_tween()
	if activated:
		cooldown.start(1)
		canBoost = false
		boost.start(.5)
		particles_boost.emitting = true
		#PlayAnim(Boost)
		$move.paused = true
		$Audio_boost.play()
		if abs(direction_x) < 1 && direction_y == 0:
			tween.tween_property(self,"velocity",velocity*10,.1)
		tween.tween_property(self,"velocity",velocity*2,.1)
		isBoosted = true
		
		eq_effect.set_band_gain_db(0, -40)
		eq_effect.set_band_gain_db(1, -20)
		eq_effect.set_band_gain_db(2, -10)
		eq_effect.set_band_gain_db(3, -5)
	else:
		#PlayAnim(null)
		$move.paused = false
		isBoosted = false
		tween.tween_property(self,"velocity",Vector2(0,0),.25)
		
		eq_effect.set_band_gain_db(0, 0)
		eq_effect.set_band_gain_db(1, 0)
		eq_effect.set_band_gain_db(2, 0)
		eq_effect.set_band_gain_db(3, 0)

func CoinSFX():
	particles_coin.emitting = true
	$Audio_coin.play()

func PauseTimers(b:bool):
	$move.paused = b
	$Cooldown.paused = b
	$Boost.paused = b
	#pause animations

func PauseWalk(b:bool):
	$move.paused = b

func edit_canMove(b:bool): 
	canMove = !b
	PauseWalk(b)
func edit_isSlowed(b:bool): isSlowed = b

func _on_health_comp_dead() -> void:
	animated_sprite_2d.animation = "dead"
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

func _on_viewport_size_changed():
	viewport_size = get_viewport().size


func _on_just_clicked_timeout() -> void:
	isJustClicked = false
	#print("timeout")
	pass # Replace with function body.
