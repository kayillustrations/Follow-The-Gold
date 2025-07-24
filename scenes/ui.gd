extends Control

const HEART = preload("res://ui/heart.tscn")

@onready var timer: Timer = $Timer

@onready var min: Label = $ColorRect/VBoxContainer/HBox/Min
@onready var sec: Label = $ColorRect/VBoxContainer/HBox/Sec
@onready var millisec: Label = $ColorRect/VBoxContainer/HBox/Millisec

@onready var health: Label = $ColorRect/VBoxContainer/HBox2/Health
@onready var hit: Label = $ColorRect/VBoxContainer/HBox3/Hit
@onready var coins: Label = $ColorRect/VBoxContainer/HBox4/Coins

@onready var hearts = $Health/HBoxContainer


func _ready() -> void:
	SignalBus.update_ui.connect(_update_all)
	SignalBus.GamePaused.connect(PauseTimer)
	SignalBus.isDamaged.connect(_update_health)

func _update_all():
	_update_obstacles()
	_update_coins()

func _update_time():
	if GameManager.current_time[0]<10:
		%Millisec.text = "0" + str(GameManager.current_time[0])
	else: %Millisec.text = str(GameManager.current_time[0])
	if GameManager.current_time[1]<10:
		%Sec.text = "0" + str(GameManager.current_time[1])
	else: %Sec.text = str(GameManager.current_time[1])
	if GameManager.current_time[2]<10:
		%Min.text = "0" + str(GameManager.current_time[2])
	else: %Min.text = str(GameManager.current_time[2])
	pass

func ResetHealth():
	var current_hearts:int = 0 
	current_hearts = hearts.get_child_count()
	while current_hearts < 3:
		var temp = HEART.instantiate()
		hearts.add_child(temp)
		current_hearts += 1

func _update_health(b:bool):
	if !b:return
	health.text = str(GameManager.current_health)
	hearts.get_children().pick_random().queue_free()
	pass

func _update_obstacles():
	hit.text = str(GameManager.obstacles_hit)
	pass

func _update_coins():
	%Coins.text = str(GameManager.coins_collected)
	pass

func ClearTimer():
	GameManager.current_time = [0,0,0]
	timer.start(.1)
	_update_time()

func PauseTimer(isPaused:bool):
	timer.paused = isPaused

func _on_timer_timeout() -> void:
	GameManager.total_time_milli += 1
	CheckTimeArray(0)

func CheckTimeArray(current_int):
	GameManager.current_time[current_int] += 1
	if GameManager.current_time[current_int] > 59 && GameManager.current_time[current_int+1] != null:
		GameManager.current_time[current_int] = 0
		CheckTimeArray(current_int+1)
	_update_time()
	timer.start(.1)
