## Game-specific functions, settings and variables
extends Node

#-----Player Stats-----
var player:CharacterBody2D
var max_health: int = 5

#------Universal------
var isPaused: bool = false

var current_health: int
var obstacles_hit: int
var coins_collected: int

var coins_spawned: int
var obstacles_spawned: int

var current_speed: float = 300.0

#--------Data---------
var data: Dictionary
var all_items: Array
#---------------------
func _ready() -> void:
	ResetDailyStats()
	pass

func ResetLevel():
	ResetDailyStats()
	SceneLoader.load_scene(SceneLoader.level_path)

func PauseGame(b: bool):
	isPaused = b
	SignalBus.GamePaused.emit(b)
	pass

func ResetDailyStats():
	GameManager.current_health = max_health
	obstacles_hit = 0
	coins_collected = 0
	coins_spawned = 0
	obstacles_spawned = 0
	current_speed = 300.0
	SignalBus.update_ui.emit()
	pass
