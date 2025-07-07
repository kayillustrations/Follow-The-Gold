extends Camera2D

@onready var shaders: CanvasLayer = $"../Shaders"
@onready var fog: ColorRect = $"../Shaders/Fog"
@onready var distortion: ColorRect = $"../Shaders/Distortion"
@onready var pink: ColorRect = $"../Shaders/Pink"

@onready var parallaxes = $"../Stationary/Parallax".get_children()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.isDisoriented.connect(Disorient)
	SignalBus.isBlinded.connect(Blind)
	SignalBus.GamePaused.connect(Parallax)
	SignalBus.GameStarted.connect(Controls)
	TurnOffShaders()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !GameManager.isStarted:
		if Input.is_anything_pressed():
			GameManager.StartedGame(true)
	if !GameManager.isPaused:
		position = GameManager.player.global_position

func TurnOffShaders():
	shaders.visible = true
	fog.visible = false
	distortion.visible = false
	pink.visible = false
	Parallax(true)

func Controls(b:bool):
	$"../Controls".visible = !b

func Parallax(isPaused:bool):
	var scroll_speed
	if isPaused: scroll_speed = 0
	else: scroll_speed = -150
	for i in parallaxes.size():
		parallaxes[i].autoscroll.y = scroll_speed

func Disorient(activate): 
	FadeShader(distortion,activate)
	FadeShader(pink,activate)

func Blind(activate):
	FadeShader(fog,activate)

func FadeShader(shader:ColorRect,activate:bool):
	var temp_tween:= create_tween()
	if activate:
		temp_tween.tween_property(shader,"material:shader_parameter/alpha",0,.01)
		shader.visible = true
		temp_tween.tween_property(shader,"material:shader_parameter/alpha",1,.25)
	else: 
		temp_tween.tween_property(shader,"material:shader_parameter/alpha",0,.25)
