extends Node

@export var effect: SignalBus.Effects

func _on_area_entered(area: Area2D) -> void:
	if area.name == "HealthComp":
		area.ApplyEffect(effect)
	else: printerr("NotHealthComp")

func _on_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
