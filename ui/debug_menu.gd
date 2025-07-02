extends Control

@onready var submenu1_panel: Panel = $"Sub Menu"
@onready var submenu2_panel:Panel = $"Sub Menu2"
@onready var submenu1_button:Button = %Button
@onready var submenu2_button:Button = %Button2

func _ready() -> void:
	ResetDebug()

func _on_visibility_changed() -> void:
	if !visible:
		ResetDebug()

func ResetDebug():
	return
	submenu1_panel.visible = false
	submenu1_button.disabled = false
	submenu2_panel.visible = false
	submenu2_button.disabled = false

func _on_pause_pressed() -> void:
	GameManager.PauseGame(!GameManager.isPaused)

func _on_save_pressed() -> void:
	GameSave.SaveGame()

func _on_bid_pressed() -> void:
	submenu1_panel.visible = true
	submenu1_button.disabled = true
	submenu2_button.disabled = false
	submenu2_panel.visible = false

func _on_knife_pressed() -> void:
	submenu1_panel.visible = false
	submenu1_button.disabled = false
	submenu2_button.disabled = true
	submenu2_panel.visible = true
