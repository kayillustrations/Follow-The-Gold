extends Control

@onready var timer: Timer = $Timer
@onready var restart: Button = $Restart

@onready var min: Label = $ColorRect/VBoxContainer/HBox/Min
@onready var sec: Label = $ColorRect/VBoxContainer/HBox/Sec
@onready var millisec: Label = $ColorRect/VBoxContainer/HBox/Millisec

@onready var health: Label = $ColorRect/VBoxContainer/HBox2/Health
@onready var hit: Label = $ColorRect/VBoxContainer/HBox3/Hit
@onready var coins: Label = $ColorRect/VBoxContainer/HBox4/Coins

var time:Array = [0,0,0] #milliseconds, seconds, minutes

func _ready() -> void:
	timer.start(.1)
	SignalBus.update_ui.connect(_update_all)

func _update_all():
	_update_health()
	_update_obstacles()
	_update_coins()

func _update_time(time):
	if time[0]<10:
		millisec.text = "0" + str(time[0])
	else: millisec.text = str(time[0])
	if time[1]<10:
		sec.text = "0" + str(time[1])
	else: sec.text = str(time[1])
	if time[2]<10:
		min.text = "0" + str(time[2])
	else: min.text = str(time[2])
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


func _on_timer_timeout() -> void:
	CheckTimeArray(0)

func CheckTimeArray(current_int):
	time[current_int] += 1
	if time[current_int] > 59 && time[current_int+1] != null:
		time[current_int] = 0
		CheckTimeArray(current_int+1)
	_update_time(time)
	timer.start(.1)


func _on_restart_pressed() -> void:
	time = [0,0,0]
	GameManager.ResetLevel()
	pass # Replace with function body.
