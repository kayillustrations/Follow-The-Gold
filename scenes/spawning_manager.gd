extends Node2D

@onready var moving: Node2D = $"../Moving"

@onready var sidewalks: Node2D = $Sidewalks
@onready var inside_bounds: Node2D = $"Inside Bounds"
@onready var sewers: Node2D = $Sewers
@onready var outside_bounds: Node2D = $"Outside Bounds"

@onready var coin_timer: Timer = $"Coin Timer"
var coin_wait: Array[float] = [1,5]

@onready var obs_timer: Timer = $"Obs Timer"
var obstacle_wait: Array[float]

@onready var sewer_timer: Timer = $"Sewer Timer"
var sewer_wait = 2

var offset:= Vector2(900.0/2.0,0)
var last_marker:Marker2D

@onready var enemy_timer: Timer = $"Enemy Timer"

func _ready() -> void:
	SignalBus.GameStarted.connect(StartTimers)
	SignalBus.GamePaused.connect(PauseTimers)
	pass

func StartTimers(isStarted:bool):
	if !isStarted:
		GameManager.player.ResetPlayer()
		var children = moving.get_children()
		for i in children.size():
			if !children[i].name == "Player":
				children[i].queue_free()
		return
	ObstacleRate()
	obs_timer.start(randf_range(obstacle_wait[0],obstacle_wait[1]))
	coin_timer.start(randf_range(coin_wait[0],coin_wait[1]))
	sewer_timer.start(sewer_wait)
	enemy_timer.start(randf_range(obstacle_wait[0],obstacle_wait[1]))
	

func PauseTimers(isPaused:bool):
	obs_timer.paused = isPaused
	coin_timer.paused = isPaused
	sewer_timer.paused = isPaused
	enemy_timer.paused = isPaused

func ObstacleRate():
	if GameManager.current_time[2] > 1: #over 1min
		obstacle_wait = [.25,1]
	elif GameManager.current_time[1] > 30: #over 30sec
		obstacle_wait = [1,2]
	elif GameManager.current_time[1] > 15: #over 15sec
		obstacle_wait = [1,3]
	else: obstacle_wait = [2,4]

func EnemyRate():
	if GameManager.current_time[2] > 1: #over 1min
		obstacle_wait = [.25,1]
	elif GameManager.current_time[1] > 30: #over 30sec
		obstacle_wait = [1,2]
	elif GameManager.current_time[1] > 15: #over 15sec
		obstacle_wait = [1,3]
	else: obstacle_wait = [2,4]

func Spawn(obstacle:int):
	var location:Vector2
	var instance:PackedScene
	match obstacle:
		SignalBus.Obstacles.COIN:
			location = ChooseChild(inside_bounds) - offset
			instance = preload("res://objects/coin.tscn")
		SignalBus.Obstacles.PUDDLE:
			location = ChooseChild(inside_bounds) - offset
			instance = preload("res://objects/obs_puddle.tscn")
		SignalBus.Obstacles.SEWER:
			location = ChooseChild(sewers)
			instance = preload("res://objects/obs_sewer.tscn")
		SignalBus.Obstacles.POPPY:
			location = ChooseChild(sidewalks) + Vector2(100 * randf_range(-1,1),0)
			instance = preload("res://objects/obs_poppy.tscn")
		SignalBus.Obstacles.RAT:
			location = outside_bounds.get_children().pick_random().position
			instance = preload("res://objects/obs_rat.tscn")
		SignalBus.Obstacles.CROW:
			location = ChooseChild(inside_bounds) - offset
			instance = preload("res://objects/obs_crow.tscn")
	location.y += position.y
	var temp_obs:Node2D = instance.instantiate()
	temp_obs.position = location
	moving.add_child(temp_obs)
	temp_obs.Config()
	if temp_obs.get_child(0).name == "Path2D" && location.x > 0: 
		temp_obs.scale.x *= -1

func ChooseInsideShape(shape:CollisionShape2D):
	var rand_x = randf_range(0, shape.shape.size.x)
	var rand_y = randf_range(0, shape.shape.size.y)
	return Vector2(rand_x,rand_y)

func ChooseChild(parent):
	var children:Array = parent.get_children()
	var chosen = children.pick_random()
	if chosen.is_class("Marker2D"):
		while chosen == last_marker:
			chosen = children.pick_random()
		last_marker = chosen
		return chosen.position
	else: 
		return ChooseInsideShape(chosen)


func _on_coin_timer_timeout() -> void:
	Spawn(SignalBus.Obstacles.COIN)
	GameManager.coins_spawned += 1
	coin_timer.start(randf_range(coin_wait[0],coin_wait[1]))

func _on_sewer_timer_timeout() -> void:
	GameManager.obstacles_spawned += 1
	Spawn(SignalBus.Obstacles.SEWER)
	sewer_timer.start(sewer_wait)
	pass # Replace with function body.

func _on_obs_timer_timeout() -> void:
	GameManager.obstacles_spawned += 1
	Spawn(randi_range(SignalBus.Obstacles.PUDDLE,SignalBus.Obstacles.POPPY))
	ObstacleRate()
	obs_timer.start(randf_range(obstacle_wait[0],obstacle_wait[1]))
	pass # Replace with function body.

func _on_enemy_timer_timeout() -> void:
	GameManager.obstacles_spawned += 1
	Spawn(randi_range(SignalBus.Obstacles.RAT,SignalBus.Obstacles.CROW))
	EnemyRate()
	enemy_timer.start(randf_range(obstacle_wait[0],obstacle_wait[1])*2)
	pass # Replace with function body.
