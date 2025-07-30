extends Control

var starts_focus: Button
var is_focused: Button

func _ready() -> void:
	starts_focus = $Panel/Start
	if SceneLoader.ui.visible:
		SceneLoader.UISceneActivate(SceneLoader.ui)
		SceneLoader.ui.timer.stop()
	SceneLoader.inMenu = true
	SceneLoader.ConnectButtons(self)
	SceneLoader.DeleteAllTemp()
	MusicManager._switchmusic("res://sound/music/titlescreenloop_v1.ogg", "res://sound/music/titlescreenloop_v1_wrappedloop.ogg", -4)

func _process(delta: float) -> void:
	pass
	#if Input.is_anything_pressed() && is_focused == null && !SceneLoader.inTempScene:
		#starts_focus.grab_focus()
		#is_focused = starts_focus
		#return
	#if Input.is_action_just_pressed("right"):
		#is_focused.focus_neighbor_right
	#if Input.is_action_just_pressed("left"):
		#is_focused.focus_neighbor_left
	#if Input.is_action_just_pressed("up"):
		#is_focused.focus_neighbor_top
	#if Input.is_action_just_pressed("down"):
		#is_focused.focus_neighbor_bottom
	#if Input.is_action_just_pressed("ui_accept"):
		#is_focused.release_focus()
		#is_focused = null
	#if is_focused: print(is_focused.name)

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
