extends Area2D

func _on_area_entered(area: Area2D) -> void:
	#print("delete",area.get_parent().name)
	area.parent.queue_free()
	pass # Replace with function body.
