extends Control

@onready var timer: Timer = $Timer

@onready var min: Label = $ColorRect/VBoxContainer/HBox/Min
@onready var sec: Label = $ColorRect/VBoxContainer/HBox/Sec
@onready var millisec: Label = $ColorRect/VBoxContainer/HBox/Millisec

@onready var health: Label = $ColorRect/VBoxContainer/HBox2/Health
@onready var hit: Label = $ColorRect/VBoxContainer/HBox3/Hit
@onready var coins: Label = $ColorRect/VBoxContainer/HBox4/Coins


func _ready() -> void:
	SignalBus.update_ui.connect(_update_all)
	SignalBus.GamePaused.connect(PauseTimer)

func _update_all():
	_update_health()
	_update_obstacles()
	_update_coins()

func _update_time():
	if GameManager.current_time[0]<10:
		millisec.text = "0" + str(GameManager.current_time[0])
	else: millisec.text = str(GameManager.current_time[0])
	if GameManager.current_time[1]<10:
		sec.text = "0" + str(GameManager.current_time[1])
	else: sec.text = str(GameManager.current_time[1])
	if GameManager.current_time[2]<10:
		min.text = "0" + str(GameManager.current_time[2])
	else: min.text = str(GameManager.current_time[2])
	pass

func _update_health():
	health.text = str(GameManager.current_health)
	pass

func _update_obstacles():
	hit.text = str(GameManager.obstacles_hit)
	pass

func _update_coins():
	coins.text = str(GameManager.coins_collected)
	pass


func PauseTimer(isPaused:bool):
	timer.paused = isPaused

func _on_timer_timeout() -> void:
	CheckTimeArray(0)

func CheckTimeArray(current_int):
	GameManager.current_time[current_int] += 1
	if GameManager.current_time[current_int] > 59 && GameManager.current_time[current_int+1] != null:
		GameManager.current_time[current_int] = 0
		CheckTimeArray(current_int+1)
	_update_time()
	timer.start(.1)

func _on_restart_pressed() -> void:
	SceneLoader.LoadGame()
