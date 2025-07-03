extends Camera2D

@onready var canvas_layer: CanvasLayer = $"../CanvasLayer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canvas_layer.visible = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = GameManager.player.global_position
	pass
