extends CharacterBody2D

@onready var health_comp: HealthComp = $HealthComp
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var screen_dimensions = Vector2(get_viewport().size)

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var player_position_uv : Vector2

func _ready() -> void:
	GameManager.player = self

func _process(delta) -> void:
	if SignalBus.isBlinded: Blindness()

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

func _on_health_comp_damaged() -> void:
	pass

func _on_health_comp_dead() -> void:
	pass # Replace with function body.

func Blindness():
	# convert player position to UV position
	player_position_uv = global_position / screen_dimensions
	# Set shader to player position
	%Vignette.material.set_shader_parameter("player_position",player_position_uv)
