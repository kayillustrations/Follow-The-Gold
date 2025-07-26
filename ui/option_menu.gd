extends Control

@onready var sfx_index: int = AudioServer.get_bus_index("SFX")
@onready var music_index: int = AudioServer.get_bus_index("Music")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if SceneLoader.inMenu:
		$ColorRect.visible = true
	%SFX_Slider.value = GameSave.volume_sfx
	%Music_Slider.value = GameSave.volume_music
	pass # Replace with function body.


func _on_button_pressed() -> void:
	SceneLoader.DeleteTempScene(self)
	pass # Replace with function body.

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_index,linear_to_db(value))
	pass # Replace with function body.

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_index,linear_to_db(value))
	pass # Replace with function body.


func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	GameSave.volume_sfx = %SFX_Slider.value
	GameSave.SaveSettings()
	pass # Replace with function body.

func _on_music_slider_drag_ended(value_changed: bool) -> void:
	GameSave.volume_music = %Music_Slider.value
	GameSave.SaveSettings()
	pass # Replace with function body.
