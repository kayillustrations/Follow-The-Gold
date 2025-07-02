extends StaticBody2D

func _on_area_2d_area_entered(area: Area2D) -> void:
	GameManager.coins_collected += 1
	SignalBus.update_ui.emit()
	queue_free()
	pass # Replace with function body.
