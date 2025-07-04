extends Camera2D

@onready var shaders: CanvasLayer = $"../Shaders"
@onready var fog: ColorRect = $"../Shaders/Fog"
@onready var distortion: ColorRect = $"../Shaders/Distortion"
@onready var pink: ColorRect = $"../Shaders/Pink"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shaders.visible = true
	fog.visible = false
	distortion.visible = false
	pink.visible = false
	SignalBus.isDisoriented.connect(Disorient)
	SignalBus.isBlinded.connect(Blind)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = GameManager.player.global_position
	pass

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
