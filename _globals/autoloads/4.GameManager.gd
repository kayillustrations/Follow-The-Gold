## Game-specific functions, settings and variables
extends Node

#-----Player Stats-----
var player:CharacterBody2D
var player_speed: float = 200
var max_current_speed: float = 200
var max_health: int = 2
 
#------Universal------
var isPaused: bool = false
var isStarted: bool = false

var current_health: int
var obstacles_hit: int
var coins_collected: int
var current_time: Array = [0,0,0] #milliseconds, seconds, minutes

var coins_spawned: int
var obstacles_spawned: int

var b_movement:float = -150

#--------Data---------
var data: Dictionary
var all_items: Array
#---------------------

func _ready() -> void:
	SignalBus.dead.connect(EndGame)

func EndGame():
	var end_scene = SceneLoader.AddTempScene(SceneLoader.end_menu)
	end_scene.Config()
	pass

func StartedGame(b:bool):
	isStarted = b
	SignalBus.GameStarted.emit(b)
	PauseGame(!b)

func PauseGame(b: bool):
	isPaused = b
	SignalBus.GamePaused.emit(b)
	pass

func ResetGame():
	current_health = max_health
	obstacles_hit = 0
	coins_collected = 0
	coins_spawned = 0
	obstacles_spawned = 0
	SceneLoader.ui.ClearTimer()
	SignalBus.update_ui.emit()
	StartedGame(false)
	pass
