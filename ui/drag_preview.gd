extends Sprite2D

signal dropped

var current_node:Node

func _process(delta:float)-> void:
	global_position = get_global_mouse_position()
	
	if Input.is_action_just_released("release"):
		dropped.emit()
		queue_free()
