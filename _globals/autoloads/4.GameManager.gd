## Game-specific functions, settings and variables
extends Node

#-----Player Stats-----
var player:CharacterBody2D
var player_speed: float = 200
var max_current_speed: float = 200
var max_health: int = 3
 
#------Universal------
var isPaused: bool = false
var isStarted: bool = false
var usingMouse: bool = false

var current_health: int
var obstacles_hit: int
var coins_collected: int
var current_time: Array = [0,0,0] #milliseconds, seconds, minutes
var total_time_milli: int

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
	MusicManager._switchmusic("res://sound/music/gameover_v1_cutloop.ogg", "res://sound/music/gameover_v1_wrappedloop.ogg", -10)
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
	MusicManager._switchmusic("res://sound/music/mainlevel_v2_cutloop.ogg", "res://sound/music/mainlevel_v2_wrappedloop.ogg", -10)
	current_health = max_health
	obstacles_hit = 0
	coins_collected = 0
	coins_spawned = 0
	obstacles_spawned = 0
	total_time_milli = 0
	SceneLoader.ui.ClearTimer()
	SceneLoader.ui.ResetHealth()
	SignalBus.update_ui.emit()
	MusicManager._restartmusic()
	StartedGame(false)
	pass
