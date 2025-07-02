## Game-specific functions, settings and variables
extends Node

#-----Player Stats-----

#------Universal------
var isPaused: bool = false

#--------Data---------
var data: Dictionary
var all_items: Array

#---------------------
func _ready() -> void:
	data = Utils.load_data_into_dict("Items")
	all_items = Utils.create_item_array(data,"",null)
	pass

func PauseGame(b: bool):
	isPaused = b
	SignalBus.GamePaused.emit(b)
	pass

func ResetDailyStats():
	pass

func ConfigItems():
	pass
