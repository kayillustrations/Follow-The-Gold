extends Control


func _on_start_pressed() -> void:
	SceneLoader.LoadGame()


func _on_options_pressed() -> void:
	SceneLoader.AddTempScene(SceneLoader.option_menu)
	pass # Replace with function body.


func _on_credits_pressed() -> void:
	pass # Replace with function body.
