extends Area2D

@export var effect: SignalBus.Effects
@onready var parent:=get_parent()

var isObstacle:bool

func _ready() -> void:
	isObstacle = get_collision_layer_value(3)
	if parent.name == "PathFollow2D":
		parent = $"../../.."

func _on_area_entered(area: Area2D) -> void:
	if area.name == "HealthComp":
		area.ApplyEffect(effect)
		if isObstacle: 
			GameManager.obstacles_hit += 1
			SignalBus.update_ui.emit()
	else: printerr("NotHealthComp")

func _on_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
