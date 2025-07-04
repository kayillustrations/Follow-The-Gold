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

func _ready() -> void:
	SignalBus.GameStarted.connect(StartTimers)
	pass

func StartTimers():
	ObstacleRate()
	obs_timer.start(randf_range(obstacle_wait[0],obstacle_wait[1]))
	coin_timer.start(randf_range(coin_wait[0],coin_wait[1]))
	sewer_timer.start(sewer_wait)

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
			location = ChooseChild(inside_bounds)
			instance = preload("res://objects/coin.tscn")
		SignalBus.Obstacles.PUDDLE:
			location = ChooseChild(inside_bounds)
			instance = preload("res://objects/obs_puddle.tscn")
		SignalBus.Obstacles.SEWER:
			location = ChooseChild(sewers)
			instance = preload("res://objects/obs_sewer.tscn")
		SignalBus.Obstacles.POPPY:
			location = ChooseChild(sidewalks)
			instance = preload("res://objects/obs_poppy.tscn")
		SignalBus.Obstacles.RAT:
			location = ChooseChild(outside_bounds)
			instance = preload("res://objects/obs_rat.tscn")
		SignalBus.Obstacles.CROW:
			instance = preload("res://objects/obs_crow.tscn")
			location = ChooseChild(inside_bounds)
	location.y += position.y
	
	var temp_obs = instance.instantiate()
	temp_obs.position = location
	moving.add_child(temp_obs)
	pass

func ChooseInsideShape(shape:CollisionShape2D):
	var rand_x = randf_range(0, shape.shape.size.x) - (957.0/2)
	var rand_y = randf_range(0, shape.shape.size.y)
	return Vector2(rand_x,rand_y)

func ChooseChild(parent):
	var children:Array = parent.get_children()
	var chosen = children.pick_random()
	if chosen.is_class("Marker2D"):
		return chosen.position
	else: 
		return ChooseInsideShape(chosen)


func _on_coin_timer_timeout() -> void:
	Spawn(SignalBus.Obstacles.COIN)
	coin_timer.start(randf_range(coin_wait[0],coin_wait[1]))

func _on_sewer_timer_timeout() -> void:
	Spawn(SignalBus.Obstacles.SEWER)
	sewer_timer.start(sewer_wait)
	pass # Replace with function body.

func _on_obs_timer_timeout() -> void:
	Spawn(randi_range(SignalBus.Obstacles.PUDDLE,SignalBus.Obstacles.POPPY))
	ObstacleRate()
	obs_timer.start(randf_range(obstacle_wait[0],obstacle_wait[1]))
	pass # Replace with function body.

func _on_enemy_timer_timeout() -> void:
	Spawn(randi_range(SignalBus.Obstacles.RAT,SignalBus.Obstacles.CROW))
	EnemyRate()
	obs_timer.start(randf_range(obstacle_wait[0],obstacle_wait[1]))
	pass # Replace with function body.
