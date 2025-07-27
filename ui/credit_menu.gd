extends Control


func _on_x_pressed() -> void:
	SceneLoader.DeleteTempScene(self)
	pass # Replace with function body.


func _on_kay_pressed() -> void:
	OS.shell_open("https://kayillustrations.carrd.co/")
	pass # Replace with function body.


func _on_mumbo_pressed() -> void:
	OS.shell_open("https://www.youtube.com/@super_mumbo/")
	pass # Replace with function body.
