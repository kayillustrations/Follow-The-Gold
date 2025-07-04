extends Control


func _on_options_pressed() -> void:
	SceneLoader.AddTempScene(SceneLoader.option_menu)
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	SceneLoader.load_scene(SceneLoader.menu_path)
	SceneLoader.UISceneActivate(SceneLoader.ui)
	SceneLoader.DeleteAllTemp()
	pass # Replace with function body.

func _on_restart_pressed() -> void:
	SceneLoader.LoadGame()
	SceneLoader.DeleteTempScene(self)
	pass # Replace with function body.

func _on_button_pressed() -> void:
	SceneLoader.DeleteTempScene(self)
	pass # Replace with function body.
