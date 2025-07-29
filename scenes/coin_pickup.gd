extends StaticBody2D

func _physics_process(delta: float) -> void:
	if !GameManager.isPaused:
		position.y += GameManager.b_movement*delta

func Config():
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.

func _on_area_2d_body_entered(body: Node2D) -> void:
	GameManager.coins_collected += 1
	SignalBus.coinCollected.emit()
	SignalBus.update_ui.emit()
	queue_free() 
	pass # Replace with function body.
