extends Control

var eq_effect : AudioEffectEQ10

func _ready():
	eq_effect = AudioServer.get_bus_effect(1, 0)
	eq_effect.set_band_gain_db(4, -80)
	eq_effect.set_band_gain_db(5, -80)
	eq_effect.set_band_gain_db(6, -80)
	eq_effect.set_band_gain_db(7, -80)
	eq_effect.set_band_gain_db(8, -80)
	eq_effect.set_band_gain_db(9, -80)
	
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
func _exit_tree():
	eq_effect.set_band_gain_db(4, 0)
	eq_effect.set_band_gain_db(5, 0)
	eq_effect.set_band_gain_db(6, 0)
	eq_effect.set_band_gain_db(7, 0)
	eq_effect.set_band_gain_db(8, 0)
	eq_effect.set_band_gain_db(9, 0)
