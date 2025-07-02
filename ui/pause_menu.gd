extends Control

@onready var options: Button = %Options
@onready var quit: Button = %Quit


func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	SceneLoader.DeleteAllTemp()
	SceneLoader.load_scene(SceneLoader.menu_path)
	pass # Replace with function body.
