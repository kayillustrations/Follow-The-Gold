extends Control

func _ready() -> void:
	if SceneLoader.ui.visible:
		SceneLoader.UISceneActivate(SceneLoader.ui)
		SceneLoader.ui.timer.stop()
	SceneLoader.inMenu = true
	SceneLoader.ConnectButtons(self)
	SceneLoader.DeleteAllTemp()
	MusicManager._switchmusic("res://sound/music/titlescreenloop_v1.ogg", "res://sound/music/titlescreenloop_v1_wrappedloop.ogg", -8)

func _on_start_pressed() -> void:
	SceneLoader.inMenu = false
	SceneLoader.LoadGame()


func _on_options_pressed() -> void:
	SceneLoader.AddTempScene(SceneLoader.option_menu)
	pass # Replace with function body.


func _on_credits_pressed() -> void:
	SceneLoader.AddTempScene(SceneLoader.credits)
	pass # Replace with function body.


func _on_reload_pressed() -> void:
	get_tree().reload_current_scene()
