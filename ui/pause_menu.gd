extends Control


func _on_options_pressed() -> void:
	SceneLoader.AddTempScene(SceneLoader.option_menu)
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	SceneLoader.load_scene(SceneLoader.menu_path)
	pass # Replace with function body.

func _on_restart_pressed() -> void:
	SceneLoader.DeleteAllTemp()
	GameManager.ResetGame()
	pass # Replace with function body.

func _on_button_pressed() -> void:
	SceneLoader.DeleteTempScene(self)
	pass # Replace with function body.
